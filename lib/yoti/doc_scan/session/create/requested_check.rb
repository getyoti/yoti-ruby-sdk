# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedCheck
          def initialize(type, config)
            raise(TypeError, "#{self.class} cannot be instantiated") if self.class == RequestedCheck

            Validation.assert_is_a(String, type, 'type')
            @type = type

            Validation.assert_respond_to(:as_json, config, 'config')
            @config = config
          end

          def to_json(*args)
            as_json.to_json(*args)
          end

          def as_json(*_args)
            {
              type: @type,
              config: @config.as_json
            }
          end
        end
      end
    end
  end
end
