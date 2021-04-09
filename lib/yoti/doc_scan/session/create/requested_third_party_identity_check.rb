# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a third party identity check
        #
        class RequestedThirdPartyIdentityCheck < RequestedCheck
          def initialize(config)
            Validation.assert_is_a(
              RequestedThirdPartyIdentityCheckConfig,
              config,
              'config'
            )

            super(Constants::THIRD_PARTY_IDENTITY, config)
          end

          #
          # @ return [RequestedThirdPartyIdentityCheckBuilder]
          #
          def self.builder
            RequestedThirdPartyIdentityCheckBuilder.new
          end
        end

        #
        # The confiuration applied when creating a {RequestedThirdPartyIdentityCheck}
        #
        class RequestedThirdPartyIdentityCheckConfig
          def as_json(*_args)
            {}
          end
        end

        #
        # Builder to assist the creation of {RequestedThirdPartyIdentityCheck}
        #
        class RequestedThirdPartyIdentityCheckBuilder
          #
          # @return [RequestedThirdPartyIdentityCheck]
          #
          def build
            config = RequestedThirdPartyIdentityCheckConfig.new
            RequestedThirdPartyIdentityCheck.new(config)
          end
        end
      end
    end
  end
end
