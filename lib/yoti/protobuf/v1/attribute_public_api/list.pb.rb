require 'protobuf/message'
require_relative 'attribute.pb'

module Yoti
  module Protobuf
    module V1
      module Attrpubapi
        ##
        # Message Classes
        #
        class AttributeAndId < ::Protobuf::Message; end
        class AttributeAndIdList < ::Protobuf::Message; end
        class AttributeList < ::Protobuf::Message; end

        ##
        # Message Fields
        #
        class AttributeAndId
          optional Yoti::Protobuf::V1::Attrpubapi::Attribute, :attribute, 1
          optional :bytes, :attribute_id, 2
        end

        class AttributeAndIdList
          repeated Yoti::Protobuf::V1::Attrpubapi::AttributeAndId, :attribute_and_id_list, 1
        end

        class AttributeList
          repeated Yoti::Protobuf::V1::Attrpubapi::Attribute, :attributes, 1
        end
      end
    end
  end
end
