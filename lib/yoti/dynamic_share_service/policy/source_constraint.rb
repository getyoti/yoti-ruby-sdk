# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # A list of anchors to require for a dynamic share
    class SourceConstraint
      DRIVING_LICENCE = 'DRIVING_LICENCE'
      PASSPORT = 'PASSPORT'
      NATIONAL_ID = 'NATIONAL_ID'
      PASS_CARD = 'PASS_CARD'

      SOURCE_CONSTRAINT = 'SOURCE'

      attr_reader :anchors

      def soft_preference
        return @soft_preference if @soft_preference

        false
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        obj = {
          type: SOURCE_CONSTRAINT,
          preferred_sources: {
            anchors: @anchors.map(&:as_json)
          }
        }
        obj[:preferred_sources][:soft_preference] = @soft_preference if @soft_preference
        obj
      end

      def initialize
        @anchors = []
      end

      def self.builder
        SourceConstraintBuilder.new
      end
    end

    # Builder for SourceConstraint
    class SourceConstraintBuilder
      def initialize
        @constraint = SourceConstraint.new
      end

      def with_anchor_by_value(value, sub_type)
        anchor = WantedAnchor.builder.with_value(value).with_sub_type(sub_type).build
        with_anchor(anchor)
      end

      def with_anchor(anchor)
        @constraint.anchors.push(anchor)
        self
      end

      def with_passport(sub_type = nil)
        with_anchor_by_value(SourceConstraint::PASSPORT, sub_type)
      end

      def with_driving_licence(sub_type = nil)
        with_anchor_by_value(SourceConstraint::DRIVING_LICENCE, sub_type)
      end

      def with_national_id(sub_type = nil)
        with_anchor_by_value(SourceConstraint::NATIONAL_ID, sub_type)
      end

      def with_passcard(sub_type = nil)
        with_anchor_by_value(SourceConstraint::PASS_CARD, sub_type)
      end

      def with_soft_preference(preference = true)
        @constraint.instance_variable_set(:@soft_preference, preference)
        self
      end

      def build
        Marshal.load Marshal.dump @constraint
      end
    end
  end
end
