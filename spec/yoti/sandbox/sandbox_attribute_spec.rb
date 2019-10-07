# frozen_string_literal: true

require 'yoti/sandbox'

describe 'Sandbox::Attribute' do
  let :name do
    'name'
  end
  let :value do
    'value'
  end
  let :derivation do
    'derivation'
  end
  describe '.with_anchor' do
    let :anchor do
      Sandbox::Anchor.source('anchorValue', timestamp: Time.utc(2008, 7, 6, 0, 0))
    end
    let :attribute do
      Sandbox::Attribute.new(name: name).with_anchor(anchor)
    end
    it 'adds an anchor' do
      expected = '{"name":"name","value":"","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"anchorValue","sub_type":"","timestamp":1215302400}]}'
      expect(attribute.to_json).to eql expected
    end
  end
  describe '.to_json' do
    let :attribute do
      Sandbox::Attribute.new(
        name: name,
        value: value,
        derivation: derivation,
        optional: true
      )
    end
    it 'Marshals the attribute' do
      expected = '{"name":"name","value":"value","derivation":"derivation","optional":true,"anchors":[]}'
      expect(attribute.to_json).to eql expected
    end
  end
end
