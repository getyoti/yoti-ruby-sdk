module Yoti
  #
  # A class to represent a Yoti attribute.
  #
  # A Yoti attribute consists of the attribute name, an associated
  # attribute value, and a list of Anchors from Yoti.
  #
  # It may hold one or more anchors, which specify how an attribute has been provided
  # and how it has been verified within the Yoti platform.
  #
  class Attribute
    FAMILY_NAME = 'family_name'
    GIVEN_NAMES = 'given_names'
    FULL_NAME = 'full_name'
    DATE_OF_BIRTH = 'date_of_birth'
    GENDER = 'gender'
    NATIONALITY = 'nationality'
    PHONE_NUMBER = 'phone_number'
    SELFIE = 'selfie'
    EMAIL_ADDRESS = 'email_address'
    POSTAL_ADDRESS = 'postal_address'
    STRUCTURED_POSTAL_ADDRESS = 'structured_postal_address'
    DOCUMENT_IMAGES = 'document_images'
    APPLICATION_NAME = 'application_name'
    APPLICATION_LOGO = 'application_logo'
    APPLICATION_URL = 'application_url'
    APPLICATION_RECEIPT_BGCOLOR = 'application_receipt_bgcolor'

    #
    # Gets the name of the attribute.
    #
    # @return [String]
    #
    attr_reader :name

    #
    # Retrieves the value of an attribute. If this is null, the default value for
    # the type is returned.
    #
    # @return [String]
    #
    attr_reader :value

    #
    # Sources are a subset of the anchors associated with an attribute, where the
    # anchor type is SOURCE.
    #
    # @return [Array<Yoti::Anchor>]
    #
    attr_reader :sources

    #
    # Verifiers are a subset of the anchors associated with an attribute, where the
    # anchor type is VERIFIER.
    #
    # @return [Array<Yoti::Anchor>]
    #
    attr_reader :verifiers

    #
    # Get the anchors for an attribute. If an attribute has only one SOURCE
    # Anchor with the value set to "USER_PROVIDED" and zero VERIFIER Anchors,
    # then the attribute is a self-certified one.
    #
    # @return [Array<Yoti::Anchor>]
    #
    attr_reader :anchors

    #
    # @param [String] name
    # @param [String] value
    # @param [Array<Yoti::Anchor>] sources
    # @param [Array<Yoti::Anchor>] verifiers
    # @param [Array<Yoti::Anchor>] anchors
    #
    def initialize(name, value, sources, verifiers, anchors = nil)
      @name = name
      @value = value
      @sources = sources
      @verifiers = verifiers
      @anchors = anchors
    end
  end
end
