require 'openssl'
require 'date'

module Yoti
  # Parse attribute anchors
  class AnchorProcessor
    # Define whether the search function get_anchor_value_by_oid
    # should return the next value in the array
    attr_reader :get_next

    protected :get_next

    def initialize(anchors_list)
        @anchors_list = anchors_list
        @get_next = false
    end

    def process
        result_data = { "sources" => [], "verifiers" => [] }
        anchor_types = self.anchor_types

        @anchors_list.each do |anchor|
            x509_certs_list = convert_certs_list_to_X509(anchor.origin_server_certs)
            yoti_signed_time_stamp = process_signed_time_stamp(anchor.signed_time_stamp)

            anchor.origin_server_certs.each do |cert|
                anchor_types.each do |type, oid|
                    yotiAnchor = get_anchor_by_oid(cert, oid, anchor.sub_type, yoti_signed_time_stamp, x509_certs_list)
                    if !yotiAnchor.nil? then
                        result_data[type].push(yotiAnchor)
                    end
                end
            end
        end

        return result_data
    end

    def convert_certs_list_to_X509(certs_list)
        x509_certs_list = []
        certs_list.each do |cert|
           x509_cert = OpenSSL::X509::Certificate.new cert
           x509_certs_list.push x509_cert
        end

        return x509_certs_list
    end

    def process_signed_time_stamp(signed_time_stamp_binary)
        signed_time_stamp = Yoti::Protobuf::CompubapiV3::SignedTimestamp.decode(signed_time_stamp_binary)
        time_in_sec = signed_time_stamp.timestamp/1000000
        date_time = DateTime.parse(Time.at(time_in_sec).to_s)
        return Yoti::SignedTimeStamp.new(signed_time_stamp.version, date_time)
    end

    def get_anchor_by_oid(cert, oid, sub_type, signed_time_stamp, x509_certs_list)
        asn1Obj = OpenSSL::ASN1.decode(cert)
        anchorValue = get_anchor_value_by_oid(asn1Obj, oid)

        return nil unless !anchorValue.nil?

        return Yoti::Anchor.new(anchorValue, sub_type, signed_time_stamp, x509_certs_list)
    end

    def get_anchor_value_by_oid(obj, oid)

        case obj
        when OpenSSL::ASN1::Sequence, Array
            obj.each do |child_obj|
                result = get_anchor_value_by_oid(child_obj, oid)
                if result != nil
                    return result
                end
            end
        when OpenSSL::ASN1::ASN1Data
            if obj.value.respond_to?(:to_s) && obj.value === oid
                @get_next = true
            elsif obj.value.respond_to?(:to_s) && @get_next
                rawValue = OpenSSL::ASN1.decode(obj.value)
                anchorValue = rawValue.value[0].value
                @get_next = false
                return anchorValue
            end

            return get_anchor_value_by_oid(obj.value, oid)
        else
            return nil
        end

        # In case it's not a valid object
        return nil
    end

    def anchor_types
        return { "sources" => '1.3.6.1.4.1.47127.1.1.1',
                 "verifiers" => '1.3.6.1.4.1.47127.1.1.2',
               }
    end
  end
end