# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a Check to be performed on a document
        #
        class RequestedCheck
          #
          # @param [String] type The type of the Check to create
          # @param [#as_json] config The configuration to apply to the Check
          #
          def initialize(type, config)
            raise(TypeError, "#{self.class} cannot be instantiated") if instance_of?(RequestedCheck)

            Validation.assert_is_a(String, type, 'type')
            @type = type

            Validation.assert_respond_to(:as_json, config, 'config')
            @config = config
          end

          def to_json(*_args)
            as_json.to_json
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
