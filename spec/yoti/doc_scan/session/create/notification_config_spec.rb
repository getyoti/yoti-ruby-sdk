describe 'Yoti::DocScan::Session::Create::NotificationConfig' do
  it 'serializes correctly' do
    config = Yoti::DocScan::Session::Create::NotificationConfig
             .builder
             .with_endpoint('some-endpoint')
             .with_auth_token('some-auth-token')
             .with_topic('some-topic')
             .with_topic('some-other-topic')
             .build

    expected = {
      auth_token: 'some-auth-token',
      endpoint: 'some-endpoint',
      topics: %w[some-topic some-other-topic]
    }

    expect(config.to_json).to eql expected.to_json
  end

  describe 'for resource update' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::NotificationConfig
               .builder
               .for_resource_update
               .build

      expected = {
        topics: [
          'RESOURCE_UPDATE'
        ]
      }

      expect(config.to_json).to eql expected.to_json
    end
  end

  describe 'for task completion' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::NotificationConfig
               .builder
               .for_task_completion
               .build

      expected = {
        topics: [
          'TASK_COMPLETION'
        ]
      }

      expect(config.to_json).to eql expected.to_json
    end
  end

  describe 'for check completion' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::NotificationConfig
               .builder
               .for_check_completion
               .build

      expected = {
        topics: [
          'CHECK_COMPLETION'
        ]
      }

      expect(config.to_json).to eql expected.to_json
    end
  end

  describe 'for session completion' do
    it 'serializes correctly' do
      config = Yoti::DocScan::Session::Create::NotificationConfig
               .builder
               .for_session_completion
               .build

      expected = {
        topics: [
          'SESSION_COMPLETION'
        ]
      }

      expect(config.to_json).to eql expected.to_json
    end
  end

  describe 'with duplicate topics' do
    it 'should exclude duplicate topics' do
      config = Yoti::DocScan::Session::Create::NotificationConfig
               .builder
               .with_topic('some-topic')
               .with_topic('some-topic')
               .build

      expected = {
        topics: %w[some-topic]
      }

      expect(config.to_json).to eql expected.to_json
    end
  end
end
