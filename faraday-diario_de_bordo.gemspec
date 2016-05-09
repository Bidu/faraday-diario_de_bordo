# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/diario_de_bordo/version'

Gem::Specification.new do |spec|
  spec.name          = 'faraday-diario_de_bordo'
  spec.version       = Faraday::DiarioDeBordo::VERSION
  spec.authors       = ['Bidu Dev Team', 'Jaya Dev Team']
  spec.email         = ['dev@bidu.com.br', 'bidu@jaya-apps.com.br']

  spec.summary       = 'Middleware between faraday and diario de bordo'
  spec.description   = 'Middleware to save logs for faraday requests'
  spec.homepage      = 'https://github.com/Bidu/faraday-diario_de_bordo'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'faraday', '~> 0.9'
end
