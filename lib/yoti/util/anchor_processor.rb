require 'openssl'
require 'date'

module Yoti
  # Parse attribute anchors
  class AnchorProcessor
    # Define whether the search function get_anchor_value_by_oid
    # should return the next value in the array
    attr_reader :get_next

    def initialize(anchors_list)
      @anchors_list = anchors_list
      @get_next = false
    end

    def process
      result_data = { 'sources' => [], 'verifiers' => [] }
      anchor_types = self.anchor_types

      @anchors_list.each do |anchor|
        x509_certs_list = convert_certs_list_to_x509(anchor.origin_server_certs)
        yoti_signed_time_stamp = process_signed_time_stamp(anchor.signed_time_stamp)

        anchor.origin_server_certs.each do |cert|
          anchor_types.each do |type, oid|
            yoti_anchor = get_anchor_by_oid(cert, oid, anchor.sub_type, yoti_signed_time_stamp, x509_certs_list)
            result_data[type].push(yoti_anchor) unless yoti_anchor.nil?
          end
        end
      end

      result_data
    end

    def convert_certs_list_to_x509(certs_list)
      x509_certs_list = []
      certs_list.each do |cert|
        x509_cert = OpenSSL::X509::Certificate.new cert
        x509_certs_list.push x509_cert
      end

      x509_certs_list
    end

    def process_signed_time_stamp(signed_time_stamp_binary)
      signed_time_stamp = Yoti::Protobuf::Compubapi::SignedTimestamp.decode(signed_time_stamp_binary)
      time_in_sec = signed_time_stamp.timestamp / 1000000
      date_time = Time.parse(Time.at(time_in_sec).to_s)
      Yoti::SignedTimeStamp.new(signed_time_stamp.version, date_time)
    end

    def get_anchor_by_oid(cert, oid, sub_type, signed_time_stamp, x509_certs_list)
      asn1_obj = OpenSSL::ASN1.decode(cert)
      anchor_value = get_anchor_value_by_oid(asn1_obj, oid)

      return nil if anchor_value.nil?

      Yoti::Anchor.new(anchor_value, sub_type, signed_time_stamp, x509_certs_list)
    end

    def get_anchor_value_by_oid(obj, oid)
      case obj
      when OpenSSL::ASN1::Sequence, Array
        return get_anchor_value_by_asn1_sequence(obj, oid)
      when OpenSSL::ASN1::ASN1Data
        return get_anchor_value_by_asn1_data(obj.value, oid)
      end

      # In case it's not a valid object
      nil
    end

    def get_anchor_value_by_asn1_data(value, oid)
      if value.respond_to?(:to_s) && value == oid
        @get_next = true
      elsif value.respond_to?(:to_s) && @get_next
        raw_value = OpenSSL::ASN1.decode(value)
        anchor_value = raw_value.value[0].value
        @get_next = false
        return anchor_value
      end

      get_anchor_value_by_oid(value, oid)
    end

    def get_anchor_value_by_asn1_sequence(obj, oid)
      obj.each do |child_obj|
        result = get_anchor_value_by_oid(child_obj, oid)
        return result unless result.nil?
      end
      nil
    end

    def anchor_types
      { 'sources' => '1.3.6.1.4.1.47127.1.1.1',
        'verifiers' => '1.3.6.1.4.1.47127.1.1.2' }
    end
  end
end
