require_relative 'yoti/version'
require_relative 'yoti/configuration'
require_relative 'yoti/errors'
require_relative 'yoti/ssl'

require_relative 'yoti/http/payloads/aml_address'
require_relative 'yoti/http/payloads/aml_profile'
require_relative 'yoti/http/aml_check_request'

require_relative 'yoti/http/signed_request'
require_relative 'yoti/http/profile_request'
require_relative 'yoti/http/request'

require_relative 'yoti/data_type/anchor'
require_relative 'yoti/data_type/age_verification'
require_relative 'yoti/data_type/base_profile'
require_relative 'yoti/data_type/application_profile'
require_relative 'yoti/data_type/profile'
require_relative 'yoti/data_type/attribute'
require_relative 'yoti/data_type/signed_time_stamp'
require_relative 'yoti/data_type/image'
require_relative 'yoti/data_type/image_jpeg'
require_relative 'yoti/data_type/image_png'
require_relative 'yoti/data_type/multi_value'
require_relative 'yoti/data_type/document_details'

require_relative 'yoti/util/age_processor'
require_relative 'yoti/util/anchor_processor'
require_relative 'yoti/util/log'
require_relative 'yoti/util/validation'

require_relative 'yoti/activity_details'
require_relative 'yoti/client'

require_relative 'yoti/protobuf/main'

require_relative 'yoti/dynamic_share_service/share_url'
require_relative 'yoti/dynamic_share_service/policy/wanted_attribute'
require_relative 'yoti/dynamic_share_service/policy/wanted_anchor'
require_relative 'yoti/dynamic_share_service/policy/source_constraint'
require_relative 'yoti/dynamic_share_service/policy/dynamic_policy'
require_relative 'yoti/dynamic_share_service/dynamic_scenario'
require_relative 'yoti/dynamic_share_service/extension/extension'
require_relative 'yoti/dynamic_share_service/extension/location_constraint_extension'
require_relative 'yoti/dynamic_share_service/extension/transactional_flow_extension'
require_relative 'yoti/dynamic_share_service/extension/thirdparty_attribute_extension'

require_relative 'yoti/share/extra_data'
require_relative 'yoti/share/attribute_issuance_details'

require_relative 'yoti/doc_scan/constants'
require_relative 'yoti/doc_scan/session/create/requested_check'
require_relative 'yoti/doc_scan/session/create/requested_document_authenticity_check'
require_relative 'yoti/doc_scan/session/create/requested_face_match_check'
require_relative 'yoti/doc_scan/session/create/requested_liveness_check'
require_relative 'yoti/doc_scan/session/create/requested_task'
require_relative 'yoti/doc_scan/session/create/requested_text_extraction_task'
require_relative 'yoti/doc_scan/session/create/document_filter'
require_relative 'yoti/doc_scan/session/create/document_restrictions_filter'
require_relative 'yoti/doc_scan/session/create/orthogonal_restrictions_filter'
require_relative 'yoti/doc_scan/session/create/required_document'
require_relative 'yoti/doc_scan/session/create/required_id_document'
require_relative 'yoti/doc_scan/session/create/sdk_config'
require_relative 'yoti/doc_scan/session/create/notification_config'
require_relative 'yoti/doc_scan/session/create/session_specification'

# The main module namespace of the Yoti gem
module Yoti
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    configuration.validate
  end
end
