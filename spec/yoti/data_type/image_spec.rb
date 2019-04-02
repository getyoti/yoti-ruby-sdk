require 'base64'

describe 'Yoti::Image' do
  describe 'abstract class' do
    it 'should not be intatiated' do
      expect { Yoti::Image.new('', '') }.to raise_error(TypeError, 'Image is an abstract class, so cannot be instantiated')
    end
  end
end

image_types = [
  {
    'class' => Yoti::ImageJpeg,
    'mime_type' => 'image/jpeg'
  },
  {
    'class' => Yoti::ImagePng,
    'mime_type' => 'image/png'
  }
]

image_types.each do |image_type|
  describe image_type['class'] do
    describe 'when instantiated' do
      it 'should be kind of Yoti::Image' do
        expect(image_type['class'].new('')).to be_a_kind_of(Yoti::Image)
      end
    end
    describe '.mime_type' do
      it "should return #{image_type['mime_type']}" do
        expect(image_type['class'].new('').mime_type).to eql(image_type['mime_type'])
      end
    end
    describe '.content' do
      it 'should return original image content' do
        expect(image_type['class'].new('test_image_content').content).to eql('test_image_content')
      end
    end
    describe '.base64_content' do
      it "should return base64 image content'" do
        base64_content = "data:#{image_type['mime_type']};base64,#{Base64.strict_encode64('test_image_content')}"
        expect(image_type['class'].new('test_image_content').base64_content).to eql(base64_content)
      end
    end
  end
end
