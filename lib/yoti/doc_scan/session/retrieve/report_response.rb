# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class ReportResponse
          # @return [RecommendationResponse]
          attr_reader :recommendation

          # @return [Array<BreakdownResponse>]
          attr_reader :breakdown

          #
          # @param [Hash] report
          #
          def initialize(report)
            @recommendation = RecommendationResponse.new(report['recommendation']) unless report['recommendation'].nil?

            if report['breakdown'].nil?
              @breakdown = []
            else
              Validation.assert_is_a(Array, report['breakdown'], 'breakdown')
              @breakdown = report['breakdown'].map { |breakdown| BreakdownResponse.new(breakdown) }
            end
          end
        end
      end
    end
  end
end
