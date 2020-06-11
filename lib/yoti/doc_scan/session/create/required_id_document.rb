# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequiredIdDocument < RequiredDocument
          #
          # @param [DocumentFilter] filter
          #
          def initialize(filter = nil)
            super(Constants::ID_DOCUMENT)

            Validation.assert_is_a(DocumentFilter, filter, 'filter', true)
            @filter = filter
          end

          def as_json(*_args)
            json = super
            json[:filter] = @filter.as_json unless @filter.nil?
            json
          end

          #
          # @return [RequiredIdDocumentBuilder]
          #
          def self.builder
            RequiredIdDocumentBuilder.new
          end
        end

        class RequiredIdDocumentBuilder
          #
          # @param [DocumentFilter] filter
          #
          # @return [self]
          #
          def with_filter(filter)
            @filter = filter
            self
          end

          #
          # @return [RequiredIdDocument]
          #
          def build
            RequiredIdDocument.new(@filter)
          end
        end
      end
    end
  end
end
