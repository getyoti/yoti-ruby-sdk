# frozen_string_literal: true

module Yoti
  class Image < Media
    def initialize(content, mime_type)
      raise(TypeError, "#{self.class} is an abstract class, so cannot be instantiated") if instance_of?(Image)

      super(content, mime_type)
    end
  end
end
