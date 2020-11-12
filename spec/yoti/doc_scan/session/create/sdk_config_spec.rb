describe 'Yoti::DocScan::Session::Create::SdkConfig' do
  it 'serializes correctly' do
    config = Yoti::DocScan::Session::Create::SdkConfig
             .builder
             .with_allowed_capture_methods('some-method')
             .with_primary_colour('some-colour')
             .with_secondary_colour('some-secondary-colour')
             .with_font_colour('some-font-colour')
             .with_error_url('some-error-url')
             .with_success_url('some-success-url')
             .with_locale('some-url')
             .with_preset_issuing_country('some-country')
             .with_privacy_policy_url('some-privacy-policy-url')
             .build

    expected = {
      allowed_capture_methods: 'some-method',
      primary_colour: 'some-colour',
      secondary_colour: 'some-secondary-colour',
      font_colour: 'some-font-colour',
      locale: 'some-url',
      preset_issuing_country: 'some-country',
      success_url: 'some-success-url',
      error_url: 'some-error-url',
      privacy_policy_url: 'some-privacy-policy-url'
    }

    expect(config.to_json).to eql expected.to_json
  end

  describe 'with allows camera' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::SdkConfig
               .builder
               .with_allows_camera
               .build

      expected = {
        allowed_capture_methods: 'CAMERA'
      }

      expect(config.to_json).to eql expected.to_json
    end
  end

  describe 'with allows camera and upload' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::SdkConfig
               .builder
               .with_allows_camera_and_upload
               .build

      expected = {
        allowed_capture_methods: 'CAMERA_AND_UPLOAD'
      }

      expect(config.to_json).to eql expected.to_json
    end
  end
end
