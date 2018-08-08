require 'openssl'
require 'pp'
require 'date'

module Yoti
  # Parse attribute anchors
  class AnchorProcessor
    def initialize(anchors_list)
        @anchors_list = anchors_list
        @get_next = false
    end

    def process
        result_data = { "sources" => [], "verifiers" => [] }
        anchor_types = self.anchor_types

        @anchors_list.each do |anchor|
            x509_certs_list = convert_certs_list_to_X509(anchor.origin_server_certs)
            yoti_signed_time_stamp = get_yoti_signed_time_stamp(anchor.signed_time_stamp)

            anchor.origin_server_certs.each do |cert|
                anchor_types.each do |type, oid|
                    yotiAnchor = get_anchor_by_oid(cert, oid, anchor.sub_type, yoti_signed_time_stamp, x509_certs_list)
                    if yotiAnchor != nil then
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

    def get_yoti_signed_time_stamp(proto_signed_time_stamp)
        signed_time_stamp = CompubapiV3::SignedTimestamp.decode(proto_signed_time_stamp)
        time_in_sec = signed_time_stamp.timestamp/1000000
        date_time = DateTime.parse(Time.at(time_in_sec).to_s)

        return Yoti::SignedTimeStamp.new(signed_time_stamp.version, date_time)
    end

    def get_anchor_by_oid(cert, oid, sub_type, signed_time_stamp, x509_certs_list)
        asn1 = OpenSSL::ASN1.decode(cert)
        anchorValue = get_anchor_value_by_oid_2(asn1, oid)

        #anchorValue = get_anchor_value_by_oid(asn1, oid)
        yotiAnchor = nil
        if anchorValue != nil
            yotiAnchor = Yoti::Anchor.new(anchorValue, sub_type, signed_time_stamp, x509_certs_list)
        end
        return yotiAnchor
    end

    def get_anchor_value_by_oid_2(obj, oid)

        case obj
        when OpenSSL::ASN1::Sequence, Array
            obj.each do |obj_element|
                result = get_anchor_value_by_oid_2(obj_element, oid)
                if result != nil
                    return result
                    break
                end
            end
        when OpenSSL::ASN1::ASN1Data
            if obj.value.respond_to?(:to_s) && obj.value === oid
                @getNext = true
            elsif obj.value.respond_to?(:to_s) && @getNext
                rawValue = OpenSSL::ASN1.decode(obj.value)
                anchorValue = rawValue.value[0].value
                @getNext = false
                return anchorValue
            end

            return get_anchor_value_by_oid_2(obj.value, oid)
        end

        return nil

    end

    def get_anchor_value_by_oid(obj, oid)
          case obj
          when OpenSSL::ASN1::Sequence
            obj.each do |o|
                result = get_anchor_value_by_oid(o, oid)
                if result != nil
                    return result
                end
            end
            #return :sequence => obj.to_a.map {|o| get_anchor_by_oid(o, oid)}
          when OpenSSL::ASN1::ASN1Data
            if obj.value.respond_to?(:to_s) && obj.value === oid
                @getNext = true
            elsif obj.value.respond_to?(:to_s) && @getNext
                rawValue = OpenSSL::ASN1.decode(obj.value)
                anchorValue = rawValue.value[0].value
                @getNext = false
                return anchorValue
            end
            return get_anchor_value_by_oid(obj.value, oid)
            #return :data => get_anchor_by_oid(obj.value, oid), :tag => to_tag_name(obj)
          when OpenSSL::BN

            #return :bn => obj.to_i
          when Hash
            abort('in hash')
            return obj.reduce({}) {|acc,(k,v)| acc[k] = get_anchor_value_by_oid(v, oid);acc }
          when Array
            obj.each do |childObj|
                result = get_anchor_value_by_oid(childObj, oid)
                if result != nil
                    return result
                    break
                end
            end
            #return obj.map {|kv| get_anchor_by_oid(kv, oid)}
          else

            #if obj.respond_to?(:tag)
            #  return :data => obj, :tag => to_tag_name(obj)
            #else
            #  return :data => obj
            #end
          end
          return nil
    end

    def anchor_types
        return { "sources" => '1.3.6.1.4.1.47127.1.1.1',
                 "verifiers" => '1.3.6.1.4.1.47127.1.1.2',
               }
    end

    def to_tag_name(obj)
        return "-" unless obj.respond_to?(:tag)
        return "?" unless obj.tag_class.to_s == "UNIVERSAL"
        return OpenSSL::ASN1::UNIVERSAL_TAG_NAME[obj.tag]
     end
  end
end