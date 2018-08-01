module Yoti
  # Parse attribute anchors
  class AnchorProcessor
    def initialize(anchors_list)
        @anchors_list = anchors_list
    end

    def process
        result_data = { "sources" => [], "verifiers" => [] }
        anchor_types = self.anchor_types

        @anchors_list.each do |anchor|
            anchor.origin_server_certs.each do |certificate|
                # todo Decode certificate as ASN1 format
                anchor_types.each do |type, oid|
                    # todo look for a match
                end
            end
            # yotiAnchor = Yoti::Anchor.new('test', anchor.sub_type, anchor.signed_time_stamp, anchor.origin_server_certs)
            #result_data["sources"].push(yotiAnchor)
        end
        return result_data
    end

    def convert_certs_list_to_X509(certs_list)
    end

    def convert_cert_to_X509(certificate)
    end


    def anchor_types
        return { sources: '1.3.6.1.4.1.47127.1.1.1',
                 verifiers: '1.3.6.1.4.1.47127.1.1.2',
               }
    end
  end
end