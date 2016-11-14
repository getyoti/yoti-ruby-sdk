require 'protobuf/message'

module Yoti
  module Protobuf
    module V1
      module Compubapi
        ##
        # Message Classes
        #
        class EncryptedData < ::Protobuf::Message; end

        ##
        # Message Fields
        #
        class EncryptedData
          optional :bytes, :iv, 1
          optional :bytes, :cipher_text, 2
        end
      end
    end
  end
end
