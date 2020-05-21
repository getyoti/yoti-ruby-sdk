# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a Task to be performed on each document
        #
        class RequestedTask
          #
          # @param [String] type The type of the Task to create
          # @param [#as_json] config Configuration to apply to the Task
          #
          def initialize(type, config)
            raise(TypeError, "#{self.class} cannot be instantiated") if self.class == RequestedTask

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
