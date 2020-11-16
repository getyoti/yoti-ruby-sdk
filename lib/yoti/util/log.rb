require 'logger'

module Yoti
  module Log
    class << self
      def logger
        @logger || create_logger($stdout)
      end

      def output(output_stream)
        create_logger(output_stream)
      end

      private

      def create_logger(output_stream)
        @logger = Logger.new(output_stream)
        @logger.progname = 'Yoti'
        @logger
      end
    end
  end
end
