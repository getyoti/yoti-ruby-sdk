require 'protobuf/message'
require_relative 'attribute.pb'

module Yoti
  module Protobuf
    module V1
      module Attrpubapi
        ##
        # Message Classes
        #
        class AttributeSigning < ::Protobuf::Message; end

        ##
        # Message Fields
        #
        class AttributeSigning
          optional :string, :name, 1
          optional :bytes, :value, 2
          optional Yoti::Protobuf::V1::Attrpubapi::ContentType, :content_type, 3
          optional :bytes, :artifact_signature, 4
          optional :string, :sub_type, 5
          optional :bytes, :signed_time_stamp, 6
        end
      end
    end
  end
end
