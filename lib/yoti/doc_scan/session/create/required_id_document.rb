# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequiredIdDocument < RequiredDocument
          def initialize(filter = nil)
            super(Constants::ID_DOCUMENT)

            Validation.assert_is_a(DocumentFilter, filter, 'filter', true)
            @filter = filter
          end

          def as_json(*args)
            super(args).merge(
              filter: @filter
            ).compact
          end

          def self.builder
            RequiredIdDocumentBuilder.new
          end
        end

        class RequiredIdDocumentBuilder
          def with_filter(filter)
            @filter = filter
            self
          end

          def build
            RequiredIdDocument.new(@filter)
          end
        end
      end
    end
  end
end
