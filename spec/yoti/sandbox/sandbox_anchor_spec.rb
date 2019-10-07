# frozen_string_literal: true

require 'yoti/sandbox'

describe 'Sandbox::Anchor' do
  let :value do
    'value'
  end
  let :subtype do
    'subtype'
  end
  let :timestamp do
    Time.utc(2008, 7, 6, 0, 0)
  end
  describe '.source' do
    let :anchor do
      Sandbox::Anchor.source(value, sub_type: subtype, timestamp: timestamp)
    end
    it 'creates a source anchor' do
      expected = '{"type":"SOURCE","value":"value","sub_type":"subtype","timestamp":1215302400}'
      expect(anchor.to_json).to eql expected
    end
  end
end
