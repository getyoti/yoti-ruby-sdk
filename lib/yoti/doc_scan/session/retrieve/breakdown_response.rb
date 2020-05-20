# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class BreakdownResponse
          attr_reader :sub_check, :result, :details

          def initialize(breakdown)
            Validation.assert_is_a(String, breakdown['sub_check'], 'sub_check', true)
            @sub_check = breakdown['sub_check']

            Validation.assert_is_a(String, breakdown['result'], 'result', true)
            @result = breakdown['result']

            if breakdown['details'].nil?
              @details = []
            else
              Validation.assert_is_a(Array, breakdown['details'], 'details')
              @details = breakdown['details'].map { |details| DetailsResponse.new(details) }
            end
          end
        end
      end
    end
  end
end
