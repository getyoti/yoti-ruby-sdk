# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class DocumentFilter
          #
          # @param [String] type
          #
          def initialize(type)
            raise(TypeError, "#{self.class} cannot be instantiated") if instance_of?(DocumentFilter)

            Validation.assert_is_a(String, type, 'type')
            @type = type
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            {
              type: @type
            }
          end
        end
      end
    end
  end
end
