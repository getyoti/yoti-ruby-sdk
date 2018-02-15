module Yoti
  # Manage the API's AML check requests
  class AmlCheckRequest
    def initialize(aml_profile)
      @aml_profile = aml_profile
      @payload = aml_profile.payload
      @request = request
    end

    # @return [String] a JSON representation of the AML check response
    def response
      JSON.parse(@request.body)
    end

    private

    def request
      yoti_request = Yoti::Request.new
      yoti_request.http_method = 'POST'
      yoti_request.endpoint = 'aml-check'
      yoti_request.payload = @payload
      yoti_request
    end
  end
end
