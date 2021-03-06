require 'faraday'
require 'diario_de_bordo'
require 'parameter_filter'

module Faraday
  class DiarioDeBordo::Middleware < Response::Middleware
    DEFAULT_OPTIONS = { bodies: true }

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
      filtered_body = parameter_filter.call(body)

      if filtered_body.respond_to?(:to_str)
        filtered_body.to_str
      else
        pretty_inspect(filtered_body)
      end.encode('UTF-8')
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

    def parameter_filter
      @parameter_filter ||= ParameterFilter.new(options[:filter_parameters])
    end
  end
end

Faraday::Response.register_middleware(diario_de_bordo: Faraday::DiarioDeBordo::Middleware)
