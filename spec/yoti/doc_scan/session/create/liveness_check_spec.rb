# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::LivenessCheck' do
  describe '.to_json' do
    it 'serializes the check' do
      check = Yoti::DocScan::Session::Create::LivenessCheck
              .builder
              .for_zoom_liveness
              .with_max_retries(3)
              .build

      expected = {
        type: 'LIVENESS',
        config: {
          liveness_type: 'ZOOM',
          max_retries: 3
        }
      }

      expect(check.as_json).to eql expected
      expect(check.to_json).to eql expected.to_json
    end
  end
end
