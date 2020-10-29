# frozen_string_literal: true

require 'base64'

module Yoti
  class Media
    # @return [String|bin]
    attr_reader :content

    # @return [String]
    attr_reader :mime_type

    def initialize(content, mime_type)
      @content = content
      @mime_type = mime_type
    end

    def base64_content
      "data:#{mime_type};base64,#{Base64.strict_encode64(content)}"
    end
  end
end
