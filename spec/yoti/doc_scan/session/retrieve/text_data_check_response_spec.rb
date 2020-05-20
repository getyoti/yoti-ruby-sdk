require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::TextDataCheckResponse' do
  let(:check_response) do
    Yoti::DocScan::Session::Retrieve::TextDataCheckResponse.new(
      'type' => 'some-type',
      'id' => 'some-id',
      'state' => 'some-state',
      'created' => '2006-01-02T22:04:05.123Z',
      'last_updated' => '2006-02-02T22:04:05.123Z',
      'resources_used' => %w[some-resource some-other-resource],
      'generated_media' => [
        {},
        {}
      ],
      'report' => {}
    )
  end

  it 'should be instance of CheckResponse' do
    expect(check_response).to be_a_kind_of(Yoti::DocScan::Session::Retrieve::CheckResponse)
  end

  describe '.type' do
    it 'should return type' do
      expect(check_response.type).to eql('some-type')
    end
  end

  describe '.type' do
    it 'should return ID' do
      expect(check_response.id).to eql('some-id')
    end
  end

  describe '.state' do
    it 'should return state' do
      expect(check_response.state).to eql('some-state')
    end
  end

  describe '.created' do
    it 'should return state' do
      expect(check_response.created).to eql(DateTime.new(2006, 1, 2, 22, 4, 5.123))
    end
  end

  describe '.last_updated' do
    it 'should return last_updated' do
      expect(check_response.last_updated).to eql(DateTime.new(2006, 2, 2, 22, 4, 5.123))
    end
  end

  describe '.resources_used' do
    it 'should return list of resources' do
      resources = check_response.resources_used
      expect(resources.count).to eql(2)
      expect(resources[0]).to eql('some-resource')
      expect(resources[1]).to eql('some-other-resource')
    end
  end

  describe '.generated_media' do
    it 'should return list of generated media' do
      media = check_response.generated_media
      expect(media.count).to eql(2)
      expect(media).to all(be_a(Yoti::DocScan::Session::Retrieve::GeneratedMedia))
    end

    it 'should return default to empty array' do
      check_response = Yoti::DocScan::Session::Retrieve::TextDataCheckResponse.new({})
      media = check_response.generated_media
      expect(media).to be_a(Array)
      expect(media.count).to eql(0)
    end
  end

  describe '.report' do
    it 'should return report' do
      expect(check_response.report).to be_a(Yoti::DocScan::Session::Retrieve::ReportResponse)
    end
  end
end
