# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Describes a dynamic share
    class DynamicScenario
      attr_reader :policy
      attr_reader :extensions
      attr_reader :callback_endpoint

      def initialize
        @extensions = []
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

      def with_policy(policy)
        @scenario.instance_variable_set(:@policy, policy)
        self
      end

      def with_extension(extension)
        @scenario.instance_variable_get(:@extensions) << extension
        self
      end

      def with_callback_endpoint(endpoint)
        @scenario.instance_variable_set(:@callback_endpoint, endpoint)
        self
      end
    end
  end
end
