require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::CreateSessionResult' do
  let(:result) do
    Yoti::DocScan::Session::Create::CreateSessionResult.new(
      'client_session_token_ttl' => 300,
      'client_session_token' => 'some-token',
      'session_id' => 'some-id'
    )
  end

  describe '.client_session_token_ttl' do
    it 'should return ttl' do
      expect(result.client_session_token_ttl).to eql(300)
    end
  end

  describe '.client_session_token' do
    it 'should return token' do
      expect(result.client_session_token).to eql('some-token')
    end
  end

  describe '.session_id' do
    it 'should return session ID' do
      expect(result.session_id).to eql('some-id')
    end
  end
end
