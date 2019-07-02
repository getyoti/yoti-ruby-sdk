require 'openssl'
require 'date'

module Yoti
  #
  # Parse attribute anchors
  #
  class AnchorProcessor
    #
    # @param [Array<Yoti::Protobuf::Attrpubapi::Anchor>]
    #
    def initialize(anchors_list)
      @anchors_list = anchors_list
      @get_next = false
    end

    #
    # Extract matching Attribute Anchors from list.
    #
    # @return [Array<Yoti::Anchor>]
    #
    def process
      result_data = ANCHOR_LIST_KEYS.map { |key, _value| [key, []] }.to_h

      @anchors_list.each do |anchor|
        x509_certs_list = convert_certs_list_to_X509(anchor.origin_server_certs)
        signed_time_stamp = process_signed_time_stamp(anchor.signed_time_stamp)

        x509_certs_list.each do |cert|
          cert.extensions.each do |anchor_extension|
            yoti_anchor = get_anchor(anchor_extension, anchor.sub_type, signed_time_stamp, x509_certs_list)
            next if yoti_anchor.nil?

            anchor_list_key = get_anchor_list_key_by_type(yoti_anchor.type)
            result_data[anchor_list_key].push(yoti_anchor)
          end
        end
      end

      result_data
    end

    #
    # Convert certificate list to a list of X509 certificates.
    #
    # @param [Google::Protobuf::RepeatedField] certs_list
    #
    # @return [Array<OpenSSL::X509::Certificate>]
    #
    def convert_certs_list_to_X509(certs_list)
      x509_certs_list = []
      certs_list.each do |cert|
        x509_certs_list.push OpenSSL::X509::Certificate.new(cert)
      end
      x509_certs_list
    end

    #
    # Return signed timestamp.
    #
    # @param [String] signed_time_stamp_binary
    #
    # @return [Yoti::SignedTimeStamp]
    #
    def process_signed_time_stamp(signed_time_stamp_binary)
      signed_time_stamp = Yoti::Protobuf::Compubapi::SignedTimestamp.decode(signed_time_stamp_binary)
      time_in_sec = signed_time_stamp.timestamp.quo(1000000)
      Yoti::SignedTimeStamp.new(signed_time_stamp.version, Time.at(time_in_sec))
    end

    #
    # Return Anchor for provided oid.
    #
    # @deprecated no longer in use
    #
    # @param [OpenSSL::X509::Certificate] cert
    # @param [String] oid
    # @param [String] sub_type
    # @param [Yoti::SignedTimeStamp] signed_time_stamp
    # @param [Array<OpenSSL::X509::Certificate>] x509_certs_list
    #
    # @return [Yoti::Anchor, nil]
    #
    def get_anchor_by_oid(cert, oid, sub_type, signed_time_stamp, x509_certs_list)
      asn1_obj = OpenSSL::ASN1.decode(cert)
      anchor_value = get_anchor_value_by_oid(asn1_obj, oid)

      Yoti::Anchor.new(anchor_value, sub_type, signed_time_stamp, x509_certs_list) unless anchor_value.nil?
    end

    #
    # Return Anchor value for provided oid.
    #
    # @deprecated no longer in use
    #
    # @param [OpenSSL::ASN1::Sequence, OpenSSL::ASN1::ASN1Data, Array] obj
    # @param [String] oid
    #
    # @return [String, nil]
    #
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

    #
    # Return Anchor value for ASN1 data.
    #
    # @deprecated no longer in use
    #
    # @param [OpenSSL::ASN1::ASN1Data] value
    # @param [String] oid
    #
    # @return [String, nil]
    #
    def get_anchor_value_by_asn1_data(value, oid)
      if value.respond_to?(:to_s) && value == oid
        @get_next = true
      elsif value.respond_to?(:to_s) && @get_next
        @get_next = false
        return OpenSSL::ASN1.decode(value).value[0].value
      end

      get_anchor_value_by_oid(value, oid)
    end

    #
    # Return Anchor value for ASN1 sequence.
    #
    # @deprecated no longer in use
    #
    # @param [OpenSSL::ASN1::Sequence, Array] obj
    # @param [String] oid
    #
    # @return [String, nil]
    #
    def get_anchor_value_by_asn1_sequence(obj, oid)
      obj.each do |child_obj|
        result = get_anchor_value_by_oid(child_obj, oid)
        return result unless result.nil?
      end
      nil
    end

    #
    # Mapping of anchor types to oid.
    #
    # @deprecated no longer in use
    #
    # @return [Hash]
    #
    def anchor_types
      ANCHOR_LIST_KEYS
    end

    protected

    #
    # Define whether the search function get_anchor_value_by_oid
    # should return the next value in the array
    #
    # @deprecated no longer in use
    #
    # @return [Boolean]
    #
    attr_reader :get_next

    private

    #
    # Mapping of anchor types.
    #
    ANCHOR_TYPES = {
      'SOURCE' => '1.3.6.1.4.1.47127.1.1.1',
      'VERIFIER' => '1.3.6.1.4.1.47127.1.1.2',
      'UNKNOWN' => ''
    }.freeze

    #
    # Mapping of anchor list keys.
    #
    ANCHOR_LIST_KEYS = {
      'sources' => ANCHOR_TYPES['SOURCE'],
      'verifiers' => ANCHOR_TYPES['VERIFIER'],
      'unknown' => ANCHOR_TYPES['UNKNOWN']
    }.freeze

    #
    # Get anchor type by oid.
    #
    # @param [String] oid
    #
    def get_anchor_type_by_oid(oid)
      if (type = ANCHOR_TYPES.find { |_key, value| value == oid })
        return type.first
      end

      'UNKNOWN'
    end

    #
    # Get anchor list key by type.
    #
    # @param [String] type
    #
    def get_anchor_list_key_by_type(type)
      ANCHOR_LIST_KEYS.find { |_key, value| value == ANCHOR_TYPES[type] }.first
    end

    #
    # Return an anchor for privided extension.
    #
    # @param [OpenSSL::X509::Extension] anchor_extension
    # @param [String] sub_type
    # @param [Yoti::SignedTimeStamp] signed_time_stamp
    # @param [Array<OpenSSL::X509::Certificate>] x509_certs_list
    #
    # @return [Yoti::Anchor]
    #
    def get_anchor(anchor_extension, sub_type, signed_time_stamp, x509_certs_list)
      type = get_anchor_type_by_oid(anchor_extension.oid)
      value = ANCHOR_TYPES[type].blank? ? '' : get_anchor_value(anchor_extension)

      Yoti::Anchor.new(value, sub_type, signed_time_stamp, x509_certs_list, type) unless value.nil?
    end

    #
    # Return Anchor value.
    #
    # @param [OpenSSL::X509::Extension] anchor_extension
    #
    # @return [String, nil]
    #
    def get_anchor_value(anchor_extension)
      decoded_extension = OpenSSL::ASN1.decode(anchor_extension)
      extension_value = decoded_extension.value[1] if decoded_extension.value.is_a?(Array)
      extension_value_item = extension_value.value if extension_value.is_a?(OpenSSL::ASN1::OctetString)
      if extension_value_item.is_a?(String)
        decoded = OpenSSL::ASN1.decode(extension_value_item)
        return decoded.value[0].value if decoded.value[0].is_a?(OpenSSL::ASN1::ASN1Data)
      end

      nil
    end
  end
end
