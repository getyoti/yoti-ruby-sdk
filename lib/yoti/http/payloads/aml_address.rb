module Yoti
  # Manages the AML check Address object
  class AmlAddress
    # @return [String] the country of residence in a ISO 3166 3-letter code format
    attr_accessor :country

    # @return [String] the postcode required for USA, optional otherwise
    attr_accessor :post_code

    #
    # @param [String] country
    # @param [String] post_code
    #
    def initialize(country, post_code = nil)
      raise AmlError, 'AmlAddress requires a country.' if country.to_s.empty?

      @country = country
      @post_code = post_code
    end
  end
end
