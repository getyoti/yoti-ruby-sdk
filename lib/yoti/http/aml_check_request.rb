module Yoti
  # Manage the API's AML check requests
  class AmlCheckRequest
    #
    # @param [AmlProfile] aml_profile
    #
    def initialize(aml_profile)
      @aml_profile = aml_profile
      @payload = aml_profile.payload
      @request = request
    end

    # @return [Hash] a JSON representation of the AML check response
    def response
      JSON.parse(@request.body)
    end

    private

    def request
      Yoti::Request
        .builder
        .with_http_method('POST')
        .with_base_url(Yoti.configuration.api_endpoint)
        .with_endpoint('aml-check')
        .with_query_param('appId', Yoti.configuration.client_sdk_id)
        .with_payload(@payload)
        .build
    end
  end
end
