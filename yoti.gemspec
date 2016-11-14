# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yoti/version'

Gem::Specification.new do |spec|
  spec.name          = 'yoti'
  spec.version       = Yoti::VERSION
  spec.authors       = ['Vasile Zaremba']
  spec.email         = ['vasile.zaremba@yoti.com']

  spec.summary       = 'Yoti Ruby SDK for back-end integration.'
  spec.description = <<-EOF
    This gem contains the tools you need to quickly integrate your Ruby back-end
    with Yoti, so that your users can share their identity details with your
    application in a secure and trusted way.
  EOF

  spec.homepage      = 'https://github.com/getyoti/ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2'

  spec.add_dependency 'protobuf', '~> 3.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'yardstick'
end
