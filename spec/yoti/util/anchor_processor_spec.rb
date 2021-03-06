require 'base64'

def process_anchors_list(binary_anchors_list)
  anchor = Yoti::Protobuf::Attrpubapi::Anchor.decode(Base64.decode64(binary_anchors_list))
  anchors_list = [anchor]
  anchor_processor = Yoti::AnchorProcessor.new(anchors_list)
  anchor_processor.process
end

describe 'Yoti::AnchorProcessor' do
  describe '.process' do
    context 'when processing DL Source Anchor data' do
      let(:dl_first_anchor) do
        dl_source_anchor = File.read('spec/sample-data/anchors/dl-source.txt')
        yoti_anchors = process_anchors_list(dl_source_anchor)
        yoti_anchors['sources'][0]
      end

      let(:expected_time) { Time.utc(2018, 4, 11, 12, 13, 3.923537) }

      it 'should return DRIVING_LICENCE as value' do
        expected_value = 'DRIVING_LICENCE'
        expect(dl_first_anchor.value).to eql(expected_value)
      end

      it 'should return empty sub_type' do
        expect(dl_first_anchor.sub_type).to eql('')
      end

      it 'should return 2018-04-11 13:13:03.923537 as timestamp' do
        expected_value = expected_time.strftime('%Y-%m-%d %H:%M:%S.%6N')
        date_time_str = dl_first_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S.%6N')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return timestamp as UTC' do
        time_stamp = dl_first_anchor.signed_time_stamp.time_stamp
        expect(time_stamp.to_s).to eql(expected_time.to_s)
        expect(time_stamp.utc?).to be true
      end

      it 'should return 46131813624213904216516051554755262812 as cert serial' do
        expected_value = '46131813624213904216516051554755262812'
        cert_serial = dl_first_anchor.origin_server_certs[0].serial.to_s
        expect(cert_serial).to eql(expected_value)
      end
    end

    context 'when processing Verifier Anchor data' do
      let(:verifier_first_anchor) do
        dl_source_anchor = File.read('spec/sample-data/anchors/dl-verifier.txt')
        yoti_anchors = process_anchors_list(dl_source_anchor)
        yoti_anchors['verifiers'][0]
      end

      let(:expected_time) { Time.utc(2018, 4, 11, 12, 13, 4.095238) }

      it 'should return YOTI_ADMIN as value' do
        expected_value = 'YOTI_ADMIN'
        expect(verifier_first_anchor.value).to eql(expected_value)
      end

      it 'should return empty sub_type' do
        expect(verifier_first_anchor.sub_type).to eql('')
      end

      it 'should return 2018-04-11 13:13:04.095238 as timestamp' do
        expected_value = expected_time.strftime('%Y-%m-%d %H:%M:%S.%6N')
        date_time_str = verifier_first_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S.%6N')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return timestamp as UTC' do
        time_stamp = verifier_first_anchor.signed_time_stamp.time_stamp
        expect(time_stamp.to_s).to eql(expected_time.to_s)
        expect(time_stamp.utc?).to be true
      end

      it 'should return 256616937783084706710155170893983549581 as cert serial' do
        expected_value = '256616937783084706710155170893983549581'
        cert_serial = verifier_first_anchor.origin_server_certs[0].serial.to_s
        expect(cert_serial).to eql(expected_value)
      end
    end

    context 'when processing Passport Source Anchor data' do
      pp_source_anchor = File.read('spec/sample-data/anchors/pp-source.txt')
      yoti_anchors = process_anchors_list(pp_source_anchor)
      pp_source_anchor = yoti_anchors['sources'][0]

      it 'should return PASSPORT as value' do
        expected_value = 'PASSPORT'
        expect(pp_source_anchor.value).to eql(expected_value)
      end

      it 'should return OCR sub_type' do
        expect(pp_source_anchor.sub_type).to eql('OCR')
      end

      it 'should return 2018-04-12 14:14:32.835537 as timestamp' do
        expected_value = Time.utc(2018, 4, 12, 13, 14, 32.835537).strftime('%Y-%m-%d %H:%M:%S.%6N')
        date_time_str = pp_source_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S.%6N')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return 277870515583559162487099305254898397834 as serial' do
        expected_value = '277870515583559162487099305254898397834'
        cert_serial = pp_source_anchor.origin_server_certs[0].serial.to_s
        expect(cert_serial).to eql(expected_value)
      end

      it 'should return /CN=passport-registration-server as issuer' do
        expect(pp_source_anchor.origin_server_certs[0].issuer.to_s)
          .to eql('/CN=passport-registration-server')
      end
    end

    context 'when processing unknown anchor data' do
      unknown_anchor_data = File.read('spec/sample-data/anchors/unknown-anchor.txt')
      yoti_anchors = process_anchors_list(unknown_anchor_data)
      unknown_anchor = yoti_anchors['unknown'][0]

      it 'should return empty string as value' do
        expect(unknown_anchor.value).to eql('')
      end

      it 'should return empty sub_type' do
        expect(unknown_anchor.sub_type).to eql('TEST UNKNOWN SUB TYPE')
      end

      it 'should return 2019-03-05 10:45:11.840037 as timestamp' do
        expected_value = Time.utc(2019, 3, 5, 10, 45, 11.840037).strftime('%Y-%m-%d %H:%M:%S.%6N')
        date_time_str = unknown_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S.%6N')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return /CN=document-registration-server as issuer' do
        expect(unknown_anchor.origin_server_certs[0].issuer.to_s)
          .to eql('/CN=document-registration-server')
      end

      it 'should return 228164395157066285041920465780950248577 as serial' do
        expect(unknown_anchor.origin_server_certs[0].serial.to_s)
          .to eql('228164395157066285041920465780950248577')
      end
    end
  end
  describe '.getAnchorByOid' do
    context 'when processing DL Source Anchor data' do
      dl_source_anchor = File.read('spec/sample-data/anchors/dl-source.txt')
      anchor = Yoti::Protobuf::Attrpubapi::Anchor.decode(Base64.decode64(dl_source_anchor))
      processor = Yoti::AnchorProcessor.new([])
      x509_certs_list = processor.convert_certs_list_to_X509(anchor.origin_server_certs)

      yoti_anchor = processor.get_anchor_by_oid(
        x509_certs_list[0],
        '1.3.6.1.4.1.47127.1.1.1',
        anchor.sub_type,
        processor.process_signed_time_stamp(anchor.signed_time_stamp),
        x509_certs_list
      )

      it 'should return DRIVING_LICENCE as value' do
        expected_value = 'DRIVING_LICENCE'
        expect(yoti_anchor.value).to eql(expected_value)
      end
    end
  end
  describe '.anchor_types' do
    it 'should return anchor type mapping' do
      processor = Yoti::AnchorProcessor.new([])
      expect(processor.anchor_types).to eql(
        'sources' => '1.3.6.1.4.1.47127.1.1.1',
        'verifiers' => '1.3.6.1.4.1.47127.1.1.2',
        'unknown' => ''
      )
    end
  end
end
