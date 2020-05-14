# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class Check
          def initialize(type, config = nil)
            raise(TypeError, "#{self.class} cannot be instantiated") if self.class == Check

            @type = type
            @config = config
          end

          def to_json(*args)
            as_json.to_json(*args)
          end

          def as_json(*_args)
            json = {
              type: @type
            }
            json[:config] = @config.as_json unless @config.nil?
            json
          end
        end
      end
    end
  end
end
