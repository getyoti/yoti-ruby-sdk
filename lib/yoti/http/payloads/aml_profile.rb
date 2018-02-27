module Yoti
  # Manages the AML check Profile object
  class AmlProfile
    def initialize(given_names, family_name, aml_address, ssn = nil)
      @given_names = given_names
      @family_name = family_name
      @ssn = ssn
      @address = aml_address

      raise AmlError, 'The AML request requires given names, family name and an ISO 3166 3-letter code.' if profile_invalid
      raise AmlError, 'Request for USA require a valid SSN and postcode.' if usa_invalid
    end

    # @return [Object] the AML check request body
    def payload
      {
        given_names: @given_names,
        family_name: @family_name,
        ssn: @ssn,
        address: {
          country: @address.country,
          post_code: @address.post_code
        }
      }
    end

    private

    def profile_invalid
      @given_names.to_s.empty? || @family_name.to_s.empty? || address_invalid
    end

    def address_invalid
      !@address.is_a?(AmlAddress) || @address.country.to_s.length != 3
    end

    def usa_invalid
      @address.country == 'USA' && (@ssn.to_s.empty? || @address.post_code.to_s.empty?)
    end
  end
end
