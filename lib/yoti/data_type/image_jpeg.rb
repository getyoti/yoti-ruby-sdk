module Yoti
  class ImageJpeg < Image
    def initialize(content)
      super(content, 'image/jpeg')
    end
  end
end
