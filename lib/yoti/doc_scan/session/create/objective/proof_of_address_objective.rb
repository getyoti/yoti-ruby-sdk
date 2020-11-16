# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class ProofOfAddressObjective < Objective
          def initialize
            super(Constants::PROOF_OF_ADDRESS)
          end

          #
          # @return [ProofOfAddressObjectiveBuilder]
          #
          def self.builder
            ProofOfAddressObjectiveBuilder.new
          end
        end

        class ProofOfAddressObjectiveBuilder
          #
          # @return [ProofOfAddressObjective]
          #
          def build
            ProofOfAddressObjective.new
          end
        end
      end
    end
  end
end
