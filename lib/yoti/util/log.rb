require 'logger'

module Yoti
  module Log
    class << self
      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
