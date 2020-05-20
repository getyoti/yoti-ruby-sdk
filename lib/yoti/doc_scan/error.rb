# frozen_string_literal: true

module Yoti
  module DocScan
    class RequestError < Yoti::RequestError
      def initialize(message, response = nil)
        super(message, response)
      end
    end
  end
end
