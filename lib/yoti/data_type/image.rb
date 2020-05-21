# frozen_string_literal: true

module Yoti
  class Image < Media
    def initialize(content, mime_type)
      raise(TypeError, "#{self.class} is an abstract class, so cannot be instantiated") if self.class == Image

      super(content, mime_type)
    end
  end
end
