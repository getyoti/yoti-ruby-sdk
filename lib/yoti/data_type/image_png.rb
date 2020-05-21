# frozen_string_literal: true

module Yoti
  class ImagePng < Image
    def initialize(content)
      super(content, 'image/png')
    end
  end
end
