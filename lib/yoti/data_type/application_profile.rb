module Yoti
  #
  # Profile of an application with convenience methods to access well-known attributes.
  #
  class ApplicationProfile < BaseProfile
    #
    # The name of the application.
    #
    # @return [Attribute, nil]
    #
    def name
      get_attribute(Yoti::Attribute::APPLICATION_NAME)
    end

    #
    # The URL where the application is available at.
    #
    # @return [Attribute, nil]
    #
    def url
      get_attribute(Yoti::Attribute::APPLICATION_URL)
    end

    #
    # The logo of the application that will be displayed to users that perform a share with it.
    #
    # @return [Attribute, nil]
    #
    def logo
      get_attribute(Yoti::Attribute::APPLICATION_LOGO)
    end

    #
    # The background colour that will be displayed on each receipt the user gets, as a result
    # of a share with the application.
    #
    # @return [Attribute, nil]
    #
    def receipt_bgcolor
      get_attribute(Yoti::Attribute::APPLICATION_RECEIPT_BGCOLOR)
    end
  end
end
