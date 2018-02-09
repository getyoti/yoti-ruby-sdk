module Yoti
  class AmlAddress
    attr_accessor :country, :post_code

    def initialize(country, post_code = nil)
      raise AmlError, 'AmlAddress requires a country.' if country.nil?

      @country = country
      @post_code = post_code
    end
  end
end
