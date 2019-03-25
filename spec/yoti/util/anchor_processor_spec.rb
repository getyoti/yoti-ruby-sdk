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
      dl_source_anchor = File.read('spec/sample-data/anchors/dl-source.txt')
      yoti_anchors = process_anchors_list(dl_source_anchor)
      dl_first_anchor = yoti_anchors['sources'][0]

      it 'should return DRIVING_LICENCE as value' do
        expected_value = 'DRIVING_LICENCE'
        expect(dl_first_anchor.value).to eql(expected_value)
      end

      it 'should return empty sub_type' do
        expect(dl_first_anchor.sub_type).to eql('')
      end

      it 'should return 2018-04-11 13:13:03 as timestamp' do
        expected_value = Time.utc(2018, 4, 11, 12, 13, 3).strftime('%Y-%m-%d %H:%M:%S')
        date_time_str = dl_first_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return 46131813624213904216516051554755262812 as cert serial' do
        expected_value = '46131813624213904216516051554755262812'
        cert_serial = dl_first_anchor.origin_server_certs[0].serial.to_s
        expect(cert_serial).to eql(expected_value)
      end
    end

    context 'when processing Verifier Anchor data' do
      dl_verifier_anchor = File.read('spec/sample-data/anchors/dl-verifier.txt')
      yoti_anchors = process_anchors_list(dl_verifier_anchor)
      verifier_first_anchor = yoti_anchors['verifiers'][0]

      it 'should return YOTI_ADMIN as value' do
        expected_value = 'YOTI_ADMIN'
        expect(verifier_first_anchor.value).to eql(expected_value)
      end

      it 'should return empty sub_type' do
        expect(verifier_first_anchor.sub_type).to eql('')
      end

      it 'should return 2018-04-11 13:13:04 as timestamp' do
        expected_value = Time.utc(2018, 4, 11, 12, 13, 4).strftime('%Y-%m-%d %H:%M:%S')
        date_time_str = verifier_first_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S')
        expect(date_time_str).to eql(expected_value)
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

      it 'should return empty sub_type' do
        expect(pp_source_anchor.sub_type).to eql('OCR')
      end

      it 'should return 2018-04-12 14:14:32 as timestamp' do
        expected_value = Time.utc(2018, 4, 12, 13, 14, 32).strftime('%Y-%m-%d %H:%M:%S')
        date_time_str = pp_source_anchor.signed_time_stamp.time_stamp.utc.strftime('%Y-%m-%d %H:%M:%S')
        expect(date_time_str).to eql(expected_value)
      end

      it 'should return 277870515583559162487099305254898397834 as serial' do
        expected_value = '277870515583559162487099305254898397834'
        cert_serial = pp_source_anchor.origin_server_certs[0].serial.to_s
        expect(cert_serial).to eql(expected_value)
      end
    end
  end
end
