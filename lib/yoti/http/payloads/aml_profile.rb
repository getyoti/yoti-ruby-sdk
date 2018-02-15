module Yoti
  # Manages the AML check Profile object
  class AmlProfile
    def initialize(given_names, family_name, aml_address, ssn = nil)
      @given_names = given_names
      @family_name = family_name
      @ssn = ssn
      @address = aml_address

      raise AmlError, 'The AML request requires given names, family name and an ISO 3166 3-letter code.' unless profile_valid
      raise AmlError, 'Request for USA require a valid SSN and post code.' unless usa_valid
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

    def profile_valid
      !@given_names.to_s.empty? && !@family_name.to_s.empty? && address_valid
    end

    def address_valid
      @address.is_a?(AmlAddress) && @address.country.to_s.length == 3
    end

    def usa_valid
      @address.country != 'USA' || (!@ssn.nil? && !@address.post_code.to_s.empty?)
    end
  end
end
