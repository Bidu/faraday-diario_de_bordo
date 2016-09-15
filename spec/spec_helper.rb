require 'bundler/setup'
require 'rspec'
require 'pry-nav'
require 'faraday/diario_de_bordo'

Bundler.setup

RSpec.configure do |config|
  config.order = :random
end
