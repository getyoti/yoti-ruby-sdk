module Yoti
  class AmlProfile
    def initialize(given_names, family_name, aml_address, ssn = nil)
      @given_names = given_names
      @family_name = family_name
      @ssn = ssn
      @address = aml_address

      raise AmlError, 'The AML request requires given names, family name and an ISO 3166 3-letter code.' unless profile_valid
      raise AmlError, 'The address needs to be an AmlAddress object.' unless address_valid
      raise AmlError, 'Request for USA require a valid SSN and post code.' unless usa_valid
    end

    def payload
      {
        given_names: @given_names,
        family_name: @family_name,
        ssn: @ssn,
        address: {
          post_code: @address.post_code,
          country: @address.country
        }
      }
    end

    private

    def profile_valid
      !@given_names.to_s.empty? && !@family_name.to_s.empty? && @address.country.length == 3
    end

    def address_valid
      @address.is_a?(AmlAddress)
    end

    def usa_valid
      @address.country != 'USA' || (!@ssn.nil? && !@address.post_code.nil?)
    end
  end
end
