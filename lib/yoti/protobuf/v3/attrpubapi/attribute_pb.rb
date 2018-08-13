# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: attribute.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "Yoti.Protobuf.attrpubapi_v3.Attribute" do
    optional :name, :string, 1
    optional :value, :bytes, 2
    optional :content_type, :enum, 3, "Yoti.Protobuf.attrpubapi_v3.ContentType"
    repeated :anchors, :message, 4, "Yoti.Protobuf.attrpubapi_v3.Anchor"
  end
  add_message "Yoti.Protobuf.attrpubapi_v3.Anchor" do
    optional :artifact_link, :bytes, 1
    repeated :origin_server_certs, :bytes, 2
    optional :artifact_signature, :bytes, 3
    optional :sub_type, :string, 4
    optional :signature, :bytes, 5
    optional :signed_time_stamp, :bytes, 6
  end
  add_enum "Yoti.Protobuf.attrpubapi_v3.ContentType" do
    value :UNDEFINED, 0
    value :STRING, 1
    value :JPEG, 2
    value :DATE, 3
    value :PNG, 4
    value :JSON, 5
  end
end

module Yoti
  module Protobuf
    module AttrpubapiV3
      Attribute = Google::Protobuf::DescriptorPool.generated_pool.lookup("Yoti.Protobuf.attrpubapi_v3.Attribute").msgclass
      Anchor = Google::Protobuf::DescriptorPool.generated_pool.lookup("Yoti.Protobuf.attrpubapi_v3.Anchor").msgclass
      ContentType = Google::Protobuf::DescriptorPool.generated_pool.lookup("Yoti.Protobuf.attrpubapi_v3.ContentType").enummodule
    end
  end
end
