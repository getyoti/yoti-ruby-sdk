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
require_relative 'yoti/data_type/media'
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

require_relative 'yoti/doc_scan/client'
require_relative 'yoti/doc_scan/constants'
require_relative 'yoti/doc_scan/errors'

require_relative 'yoti/doc_scan/session/create/create_session_result'
require_relative 'yoti/doc_scan/session/create/requested_check'
require_relative 'yoti/doc_scan/session/create/requested_document_authenticity_check'
require_relative 'yoti/doc_scan/session/create/requested_third_party_identity_check'
require_relative 'yoti/doc_scan/session/create/requested_id_document_comparison_check'
require_relative 'yoti/doc_scan/session/create/requested_face_match_check'
require_relative 'yoti/doc_scan/session/create/requested_liveness_check'
require_relative 'yoti/doc_scan/session/create/requested_task'
require_relative 'yoti/doc_scan/session/create/requested_text_extraction_task'
require_relative 'yoti/doc_scan/session/create/requested_supplementary_doc_text_extraction_task'
require_relative 'yoti/doc_scan/session/create/objective/objective'
require_relative 'yoti/doc_scan/session/create/objective/proof_of_address_objective'
require_relative 'yoti/doc_scan/session/create/document_filter'
require_relative 'yoti/doc_scan/session/create/document_restrictions_filter'
require_relative 'yoti/doc_scan/session/create/orthogonal_restrictions_filter'
require_relative 'yoti/doc_scan/session/create/required_document'
require_relative 'yoti/doc_scan/session/create/required_id_document'
require_relative 'yoti/doc_scan/session/create/required_supplementary_document'
require_relative 'yoti/doc_scan/session/create/sdk_config'
require_relative 'yoti/doc_scan/session/create/notification_config'
require_relative 'yoti/doc_scan/session/create/session_specification'

require_relative 'yoti/doc_scan/session/retrieve/check_response'
require_relative 'yoti/doc_scan/session/retrieve/resource_response'
require_relative 'yoti/doc_scan/session/retrieve/authenticity_check_response'
require_relative 'yoti/doc_scan/session/retrieve/id_document_comparison_check_response'
require_relative 'yoti/doc_scan/session/retrieve/breakdown_response'
require_relative 'yoti/doc_scan/session/retrieve/details_response'
require_relative 'yoti/doc_scan/session/retrieve/document_fields_response'
require_relative 'yoti/doc_scan/session/retrieve/document_id_photo_response'
require_relative 'yoti/doc_scan/session/retrieve/face_map_response'
require_relative 'yoti/doc_scan/session/retrieve/face_match_check_response'
require_relative 'yoti/doc_scan/session/retrieve/file_response'
require_relative 'yoti/doc_scan/session/retrieve/frame_response'
require_relative 'yoti/doc_scan/session/retrieve/generated_check_response'
require_relative 'yoti/doc_scan/session/retrieve/generated_media'
require_relative 'yoti/doc_scan/session/retrieve/generated_text_data_check_response'
require_relative 'yoti/doc_scan/session/retrieve/generated_supplementary_document_text_data_check_response'
require_relative 'yoti/doc_scan/session/retrieve/get_session_result'
require_relative 'yoti/doc_scan/session/retrieve/id_document_resource_response'
require_relative 'yoti/doc_scan/session/retrieve/supplementary_document_resource_response'
require_relative 'yoti/doc_scan/session/retrieve/liveness_check_response'
require_relative 'yoti/doc_scan/session/retrieve/liveness_resource_response'
require_relative 'yoti/doc_scan/session/retrieve/media_response'
require_relative 'yoti/doc_scan/session/retrieve/page_response'
require_relative 'yoti/doc_scan/session/retrieve/recommendation_response'
require_relative 'yoti/doc_scan/session/retrieve/report_response'
require_relative 'yoti/doc_scan/session/retrieve/resource_container'
require_relative 'yoti/doc_scan/session/retrieve/task_response'
require_relative 'yoti/doc_scan/session/retrieve/text_data_check_response'
require_relative 'yoti/doc_scan/session/retrieve/text_extraction_task_response'
require_relative 'yoti/doc_scan/session/retrieve/zoom_liveness_resource_response'
require_relative 'yoti/doc_scan/session/retrieve/supplementary_document_text_data_check_response'
require_relative 'yoti/doc_scan/session/retrieve/supplementary_document_text_extraction_task_response'

require_relative 'yoti/doc_scan/support/supported_documents'

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
