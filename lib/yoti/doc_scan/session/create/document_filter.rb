# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class DocumentFilter
          def initialize(type)
            raise(TypeError, "#{self.class} cannot be instantiated") if self.class == DocumentFilter

            Validation.assert_is_a(String, type, 'type')
            @type = type
          end

          def to_json(*args)
            as_json.to_json(*args)
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
