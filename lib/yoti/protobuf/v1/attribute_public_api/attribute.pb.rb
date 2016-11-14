require 'protobuf/message'

module Yoti
  module Protobuf
    module V1
      module Attrpubapi
        ##
        # Enum Classes
        #
        class ContentType < ::Protobuf::Enum
          define :UNDEFINED, 0
          define :STRING, 1
          define :JPEG, 2
          define :DATE, 3
          define :PNG, 4
        end

        ##
        # Message Classes
        #
        class Attribute < ::Protobuf::Message; end
        class Anchor < ::Protobuf::Message; end

        ##
        # Message Fields
        #
        class Attribute
          optional :string, :name, 1
          optional :bytes, :value, 2
          optional Yoti::Protobuf::V1::Attrpubapi::ContentType, :content_type, 3
          repeated Yoti::Protobuf::V1::Attrpubapi::Anchor, :anchors, 4
        end

        class Anchor
          optional :bytes, :artifact_link, 1
          repeated :bytes, :origin_server_certs, 2
          optional :bytes, :artifact_signature, 3
          optional :string, :sub_type, 4
          optional :bytes, :signature, 5
          optional :bytes, :signed_time_stamp, 6
        end
      end
    end
  end
end
