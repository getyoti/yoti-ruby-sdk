# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequiredDocument
          #
          # @param [String] type
          #
          def initialize(type)
            raise(TypeError, "#{self.class} cannot be instantiated") if self.class == RequiredDocument

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
