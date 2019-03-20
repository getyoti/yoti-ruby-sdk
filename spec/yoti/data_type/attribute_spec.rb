

def process_anchors_list(binary_anchors_list)
    anchor = Yoti::Protobuf::Attrpubapi::Anchor.decode(Base64.decode64(binary_anchors_list))
    anchors_list = [anchor]
    anchor_processor = Yoti::AnchorProcessor.new(anchors_list)
    return anchor_processor.process
end

describe 'Yoti::Attribute' do
    dl_source_anchor = File.read("spec/sample-data/anchors/dl-source.txt")
    dl_verifier_anchor = File.read("spec/sample-data/anchors/dl-verifier.txt")
    dl_sources_list = process_anchors_list(dl_source_anchor)['sources']
    dl_verifiers = process_anchors_list(dl_verifier_anchor)['verifiers']
    yotiAttribute = Yoti::Attribute.new('test_given_names', 'Test GIVEN NAMES', dl_sources_list, dl_verifiers)

    describe '.name' do
        it 'should return test_given_names' do
            expect(yotiAttribute.name).to eql('test_given_names')
        end
    end

    describe '.value' do
        it 'should return Test GIVEN NAMES' do
            expect(yotiAttribute.value).to eql('Test GIVEN NAMES')
        end
    end

    describe '.sources' do
        first_source = yotiAttribute.sources[0]

        it 'should return DRIVING_LICENCE as value' do
            expect(first_source.value).to eql('DRIVING_LICENCE')
        end
    end

    describe '.verifiers' do
        first_verifier = yotiAttribute.verifiers[0]

        it 'should return YOTI_ADMIN as value' do
            expect(first_verifier.value).to eql('YOTI_ADMIN')
        end
    end
end