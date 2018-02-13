require_relative 'yoti/version'
require_relative 'yoti/configuration'
require_relative 'yoti/errors'
require_relative 'yoti/ssl'
require_relative 'yoti/http/signed_request'
require_relative 'yoti/http/request'
require_relative 'yoti/http/profile_request'
require_relative 'yoti/activity_details'
require_relative 'yoti/client'
require_relative 'yoti/protobuf/v1/protobuf'

# The main module namespace of the Yoti gem
module Yoti
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    configuration.validate
  end
end
