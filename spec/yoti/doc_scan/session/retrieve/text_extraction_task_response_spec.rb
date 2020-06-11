require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::TextExtractionTaskResponse' do
  let(:task_response) do
    Yoti::DocScan::Session::Retrieve::TextExtractionTaskResponse.new(
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
      'generated_checks' => [
        {
          'type' => 'ID_DOCUMENT_TEXT_DATA_CHECK',
          'id' => 'some-id'
        },
        {}
      ]
    )
  end

  it 'should be instance of CheckResponse' do
    expect(task_response).to be_a_kind_of(Yoti::DocScan::Session::Retrieve::TaskResponse)
  end

  describe '.type' do
    it 'should return type' do
      expect(task_response.type).to eql('some-type')
    end
  end

  describe '.type' do
    it 'should return ID' do
      expect(task_response.id).to eql('some-id')
    end
  end

  describe '.state' do
    it 'should return state' do
      expect(task_response.state).to eql('some-state')
    end
  end

  describe '.created' do
    it 'should return state' do
      expect(task_response.created).to eql(DateTime.new(2006, 1, 2, 22, 4, 5.123))
    end
  end

  describe '.last_updated' do
    it 'should return last_updated' do
      expect(task_response.last_updated).to eql(DateTime.new(2006, 2, 2, 22, 4, 5.123))
    end
  end

  describe '.resources_used' do
    it 'should return list of resources' do
      resources = task_response.resources_used
      expect(resources.count).to eql(2)
      expect(resources[0]).to eql('some-resource')
      expect(resources[1]).to eql('some-other-resource')
    end
  end

  describe '.generated_media' do
    it 'should return list of generated media' do
      media = task_response.generated_media
      expect(media.count).to eql(2)
      expect(media).to all(be_a(Yoti::DocScan::Session::Retrieve::GeneratedMedia))
    end

    it 'should return default to empty array' do
      task_response = Yoti::DocScan::Session::Retrieve::TextExtractionTaskResponse.new({})
      media = task_response.generated_media
      expect(media).to be_a(Array)
      expect(media.count).to eql(0)
    end
  end

  describe '.generated_checks' do
    it 'should return list of generated checks' do
      checks = task_response.generated_checks
      expect(checks.count).to eql(2)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::GeneratedTextDataCheckResponse)
      expect(checks[1]).to be_a(Yoti::DocScan::Session::Retrieve::GeneratedCheckResponse)
    end

    it 'should return default to empty array' do
      task_response = Yoti::DocScan::Session::Retrieve::TextExtractionTaskResponse.new({})
      checks = task_response.generated_media
      expect(checks).to be_a(Array)
      expect(checks.count).to eql(0)
    end
  end

  describe '.generated_text_data_checks' do
    it 'should return list of generated text data checks' do
      checks = task_response.generated_text_data_checks
      expect(checks.count).to eql(1)
      expect(checks[0]).to be_a(Yoti::DocScan::Session::Retrieve::GeneratedTextDataCheckResponse)
    end
  end
end
