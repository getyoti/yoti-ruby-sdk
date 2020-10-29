# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Describes a dynamic share
    class DynamicScenario
      # @return [Yoti::DynamicSharingService::DynamicPolicy]
      attr_reader :policy

      # @return [Array<Yoti::DynamicSharingService::Extension>]
      attr_reader :extensions

      # @return [String]
      attr_reader :callback_endpoint

      def initialize
        @extensions = []
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        {
          policy: @policy,
          extensions: @extensions,
          callback_endpoint: @callback_endpoint
        }
      end

      def self.builder
        DynamicScenarioBuilder.new
      end
    end

    # Builder for DynamicScenario
    class DynamicScenarioBuilder
      def initialize
        @scenario = DynamicScenario.new
      end

      def build
        Marshal.load Marshal.dump @scenario
      end

      #
      # @param [Yoti::DynamicSharingService::DynamicPolicy] policy
      #
      def with_policy(policy)
        @scenario.instance_variable_set(:@policy, policy)
        self
      end

      #
      # @param [Yoti::DynamicSharingService::Extension] extension
      #
      def with_extension(extension)
        @scenario.instance_variable_get(:@extensions) << extension
        self
      end

      #
      # @param [String] endpoint
      #
      def with_callback_endpoint(endpoint)
        @scenario.instance_variable_set(:@callback_endpoint, endpoint)
        self
      end
    end
  end
end
