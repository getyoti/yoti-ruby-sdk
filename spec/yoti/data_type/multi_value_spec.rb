def multi_value_items
  items = [
    Yoti::ImageJpeg.new('image_1'),
    Yoti::ImagePng.new('image_2'),
    'test string',
    { name: 'test object' },
    %w[test array],
    Yoti::MultiValue.new(
      [
        Yoti::ImageJpeg.new('image_3'),
        Yoti::ImagePng.new('image_4'),
        'test string 2',
        %w[test array2],
        Yoti::MultiValue.new(
          [
            Yoti::ImageJpeg.new('image_5'),
            Yoti::ImagePng.new('image_6'),
            'test string 3',
            %w[test array3]
          ]
        )
      ]
    )
  ]
  items
end

describe 'Yoti::MultiValue' do
  describe '.items' do
    it 'should return provided array of items' do
      items = multi_value_items
      multi_value = Yoti::MultiValue.new(items)
      expect(multi_value.items).to eql(items)
    end
  end

  describe '.apply_filters' do
    it 'should apply filters to all multi values' do
      items = multi_value_items
      multi_value = Yoti::MultiValue.new(items)
      expect(multi_value.items.count).to eql(6)

      multi_value
        .allow_type(Yoti::ImageJpeg)
        .allow_type(Yoti::MultiValue)

      # First Level
      first_level = multi_value.items
      expect(first_level).to be_frozen
      expect(first_level.count).to eql(2)
      expect(first_level[0]).to be_a(Yoti::ImageJpeg)
      expect(first_level[1]).to be_a(Yoti::MultiValue)

      # Second Level
      second_level = first_level[1].items
      expect(second_level).to be_frozen
      expect(second_level.count).to eql(2)
      expect(second_level[0]).to be_a(Yoti::ImageJpeg)
      expect(second_level[1]).to be_a(Yoti::MultiValue)

      # Third Level
      third_level = second_level[1].items
      expect(third_level).to be_frozen
      expect(third_level.count).to eql(1)
      expect(third_level[0]).to be_a(Yoti::ImageJpeg)
    end
  end
end
