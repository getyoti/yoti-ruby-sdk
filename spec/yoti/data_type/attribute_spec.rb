def process_anchors_list(binary_anchors_list)
  anchor = Yoti::Protobuf::Attrpubapi::Anchor.decode(Base64.decode64(binary_anchors_list))
  anchors_list = [anchor]
  anchor_processor = Yoti::AnchorProcessor.new(anchors_list)
  anchor_processor.process
end

describe 'Yoti::Attribute' do
  dl_source_anchor = File.read('spec/sample-data/anchors/dl-source.txt')
  dl_verifier_anchor = File.read('spec/sample-data/anchors/dl-verifier.txt')
  unknown_anchor = File.read('spec/sample-data/anchors/unknown-anchor.txt')
  dl_sources_list = process_anchors_list(dl_source_anchor)['sources']
  dl_verifiers_list = process_anchors_list(dl_verifier_anchor)['verifiers']
  unknown_anchors_list = process_anchors_list(unknown_anchor)['unknown']
  anchors_list = {
    'sources' => dl_sources_list,
    'verifiers' => dl_verifiers_list,
    'unknown' => unknown_anchors_list
  }
  yoti_attribute = Yoti::Attribute.new('test_given_names', 'Test GIVEN NAMES', dl_sources_list, dl_verifiers_list, anchors_list)

  describe '.name' do
    it 'should return test_given_names' do
      expect(yoti_attribute.name).to eql('test_given_names')
    end
  end

  describe '.value' do
    it 'should return Test GIVEN NAMES' do
      expect(yoti_attribute.value).to eql('Test GIVEN NAMES')
    end
  end

  describe '.sources' do
    first_source = yoti_attribute.sources[0]

    it 'should return DRIVING_LICENCE as value' do
      expect(first_source.value).to eql('DRIVING_LICENCE')
    end
  end

  describe '.verifiers' do
    first_verifier = yoti_attribute.verifiers[0]

    it 'should return YOTI_ADMIN as value' do
      expect(first_verifier.value).to eql('YOTI_ADMIN')
    end
  end

  describe '.anchors' do
    it 'should return a list of all anchors' do
      anchors = yoti_attribute.anchors
      anchors.each do |anchor|
        expect(anchor).to be_a(Yoti::Anchor)
      end
      expect(anchors[0].type).to eql('SOURCE')
      expect(anchors[1].type).to eql('VERIFIER')
      expect(anchors[2].type).to eql('UNKNOWN')
    end
  end
end
