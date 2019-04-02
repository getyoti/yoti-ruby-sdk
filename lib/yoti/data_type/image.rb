require 'base64'

module Yoti
  class Image
    attr_reader :content
    attr_reader :mime_type

    def initialize(content, mime_type)
      raise(TypeError, 'Image is an abstract class, so cannot be instantiated') if self.class == Yoti::Image

      @content = content
      @mime_type = mime_type
    end

    def base64_content
      "data:#{mime_type};base64,#{Base64.strict_encode64(content)}"
    end
  end
end
