require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::GetSessionResult' do
  let(:session) do
    Yoti::DocScan::Session::Retrieve::GetSessionResult.new(
      'client_session_token_ttl' => 599,
      'session_id' => 'some-session-id',
      'user_tracking_id' => 'some-user-id',
      'state' => 'some-state',
      'client_session_token' => 'some-token',
      'biometric_consent' => '2006-02-02T22:04:05.123Z',
      'resources' => {
        'id_documents' => [],
        'liveness_capture' => []
      },
      'checks' => [
        {
          'type' => 'ID_DOCUMENT_AUTHENTICITY'
        },
        {
          'type' => 'LIVENESS'
        },
        {
          'type' => 'ID_DOCUMENT_FACE_MATCH'
        },
        {
          'type' => 'ID_DOCUMENT_TEXT_DATA_CHECK'
        },
        {
          'type' => 'ID_DOCUMENT_COMPARISON'
        },
        {
          'type' => 'SUPPLEMENTARY_DOCUMENT_TEXT_DATA_CHECK'
        },
        {}
      ]
    )
  end

  describe '.session_id' do
    it 'should return client session ID' do
      expect(session.session_id).to eql('some-session-id')
    end
  end

  describe '.user_tracking_id' do
    it 'should return user tracking ID' do
      expect(session.user_tracking_id).to eql('some-user-id')
    end
  end

  describe '.state' do
    it 'should return state' do
      expect(session.state).to eql('some-state')
    end
  end

  describe '.client_session_token_ttl' do
    it 'should return client session token TTL' do
      expect(session.client_session_token_ttl).to eql(599)
    end
  end

  describe '.client_session_token' do
    it 'should return client session token' do
      expect(session.client_session_token).to eql('some-token')
    end
  end

  describe '.checks' do
    describe 'when checks are available' do
      it 'should return array of checks' do
        checks = session.checks
        expect(checks.length).to eql(7)
        expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::AuthenticityCheckResponse)
        expect(checks[1]).to be_a(Yoti::DocScan::Session::Retrieve::LivenessCheckResponse)
        expect(checks[2]).to be_a(Yoti::DocScan::Session::Retrieve::FaceMatchCheckResponse)
        expect(checks[3]).to be_a(Yoti::DocScan::Session::Retrieve::TextDataCheckResponse)
        expect(checks[4]).to be_a(Yoti::DocScan::Session::Retrieve::IdDocumentComparisonCheckResponse)
        expect(checks[5]).to be_a(Yoti::DocScan::Session::Retrieve::SupplementaryDocumentTextDataCheckResponse)
        expect(checks).to all(be_a(Yoti::DocScan::Session::Retrieve::CheckResponse))
      end
    end

    describe 'when checks are not available' do
      it 'should return empty array' do
        session = Yoti::DocScan::Session::Retrieve::GetSessionResult.new({})
        checks = session.checks
        expect(checks).to be_a(Array)
        expect(checks.length).to eql(0)
      end
    end
  end

  describe '.authenticity_checks' do
    it 'should return array of AuthenticityCheckResponse' do
      checks = session.authenticity_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::AuthenticityCheckResponse)
    end
  end

  describe '.liveness_checks' do
    it 'should return array of LivenessCheckResponse' do
      checks = session.liveness_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::LivenessCheckResponse)
    end
  end

  describe '.text_data_checks' do
    it 'should return array of TextDataCheckResponse' do
      checks = session.text_data_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::TextDataCheckResponse)
    end
  end

  describe '.id_document_text_data_checks' do
    it 'should return array of TextDataCheckResponse' do
      checks = session.id_document_text_data_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::TextDataCheckResponse)
    end
  end

  describe '.supplementary_document_text_data_checks' do
    it 'should return array of SupplementaryDocumentTextDataCheckResponse' do
      checks = session.supplementary_document_text_data_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::SupplementaryDocumentTextDataCheckResponse)
    end
  end

  describe '.face_match_checks' do
    it 'should return array of FaceMatchCheckResponse)' do
      checks = session.face_match_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::FaceMatchCheckResponse)
    end
  end

  describe '.id_document_comparison_checks' do
    it 'should return array of IdDocumentComparisonResponse)' do
      checks = session.id_document_comparison_checks
      expect(checks.length).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::IdDocumentComparisonCheckResponse)
    end
  end

  describe '.resources' do
    it 'should return resource container' do
      expect(session.resources).to be_a(Yoti::DocScan::Session::Retrieve::ResourceContainer)
    end
  end

  describe '.biometric_consent_timestamp' do
    context 'when consent is provided' do
      it 'should return timestamp as DateTime' do
        biometric_consent_timestamp = session.biometric_consent_timestamp
        expect(biometric_consent_timestamp).to eql(DateTime.new(2006, 2, 2, 22, 4, 5.123))
      end
    end
    context 'when consent is not provided' do
      it 'should return nil' do
        session = Yoti::DocScan::Session::Retrieve::GetSessionResult.new({})
        expect(session.biometric_consent_timestamp).to be_nil
      end
    end
  end
end
