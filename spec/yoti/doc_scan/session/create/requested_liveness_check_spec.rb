# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::RequestedLivenessCheck' do
  describe 'for zoom liveness and with max retries' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedLivenessCheck
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

      expect(check.to_json).to eql expected.to_json
    end
  end
end
