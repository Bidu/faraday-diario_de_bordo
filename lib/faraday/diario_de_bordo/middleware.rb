require 'faraday'
require 'diario_de_bordo'

module Faraday
  class DiarioDeBordo::Middleware < Response::Middleware
    DEFAULT_OPTIONS = { bodies: true }
    FILTERED = '[FILTERED]'.freeze

    attr_reader :logger, :options, :request_body, :response_body, :started_at, :ended_at

    def initialize(app, options = {})
      super(app)
      @logger = ::DiarioDeBordo::Loggers::Database
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def call(env)
      @request_body = dump_body(env[:body]) if env[:body] && log_body?(:request)
      @started_at = Time.now
      super
    end

    def on_complete(env)
      @ended_at = Time.now
      @response_body = dump_body(env[:body]) if env[:body] && log_body?(:response)
      logger.log(response_log(env))
    end

    private

    def duration
      (ended_at - started_at)
    end

    def response_log(env)
      {
        request: request_body,
        response: response_body,
        susep: env.request_headers.delete('susep'),
        method: env.request_headers.delete('template'),
        external_id: env.request_headers.delete('external_id'),
        status_code: env.status,
        duration: duration,
        created_at: Time.now
      }
    end

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end

    def dump_body(body)
      filter_parameters!(body)

      if body.respond_to?(:to_str)
        body.to_str
      else
        pretty_inspect(body)
      end.encode('UTF-8')
    end

    def filter_parameters!(body)
      return unless body.is_a?(Hash)

      body.each do |key, value|
        if value.is_a?(Hash)
          filter_parameters!(value)
        else
          body[key] = FILTERED if options[:filter_parameters].include?(key)
        end
      end
    end

    def pretty_inspect(body)
      require 'pp' unless body.respond_to?(:pretty_inspect)
      body.pretty_inspect
    end

    def log_body?(type)
      case options[:bodies]
      when Hash then options[:bodies][type]
      else options[:bodies]
      end
    end
  end
end

Faraday::Response.register_middleware(diario_de_bordo: Faraday::DiarioDeBordo::Middleware)
