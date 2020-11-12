class YotiController < ApplicationController
  #
  # Create Session
  #
  def index
    session_spec = Yoti::DocScan::Session::Create::SessionSpecification
                   .builder
                   .with_client_session_token_ttl(600)
                   .with_resources_ttl(90_000)
                   .with_user_tracking_id('some-user-tracking-id')
                   .with_requested_check(
                     Yoti::DocScan::Session::Create::RequestedDocumentAuthenticityCheck
                     .builder
                     .build
                   )
                   .with_requested_check(
                     Yoti::DocScan::Session::Create::RequestedLivenessCheck
                     .builder
                     .for_zoom_liveness
                     .build
                   )
                   .with_requested_check(
                     Yoti::DocScan::Session::Create::RequestedFaceMatchCheck
                     .builder
                     .with_manual_check_always
                     .build
                   )
                   .with_requested_check(
                     Yoti::DocScan::Session::Create::RequestedIdDocumentComparisonCheck
                     .builder
                     .build
                   )
                   .with_requested_task(
                     Yoti::DocScan::Session::Create::RequestedTextExtractionTask
                     .builder
                     .with_manual_check_always
                     .with_chip_data_desired
                     .build
                   )
                   .with_requested_task(
                     Yoti::DocScan::Session::Create::RequestedSupplementaryDocTextExtractionTask
                     .builder
                     .with_manual_check_always
                     .build
                   )
                   .with_sdk_config(
                     Yoti::DocScan::Session::Create::SdkConfig
                     .builder
                     .with_allows_camera_and_upload
                     .with_primary_colour('#2d9fff')
                     .with_secondary_colour('#FFFFFF')
                     .with_font_colour('#FFFFFF')
                     .with_locale('en-GB')
                     .with_preset_issuing_country('GBR')
                     .with_success_url("#{request.base_url}/success")
                     .with_error_url("#{request.base_url}/error")
                     .with_privacy_policy_url("#{request.base_url}/privacy-policy")
                     .build
                   )
                   .with_required_document(
                     Yoti::DocScan::Session::Create::RequiredIdDocument
                     .builder
                     .with_filter(
                       Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
                       .builder
                       .with_included_document_types(['PASSPORT'])
                       .build
                     )
                     .build
                   )
                   .with_required_document(
                     Yoti::DocScan::Session::Create::RequiredIdDocument
                     .builder
                     .build
                   )
                   .with_required_document(
                     Yoti::DocScan::Session::Create::RequiredSupplementaryDocument
                     .builder
                     .with_objective(
                       Yoti::DocScan::Session::Create::ProofOfAddressObjective
                       .builder
                       .build
                     )
                     .build
                   )
                   .build

    create_session = Yoti::DocScan::Client.create_session(session_spec)

    session[:DOC_SCAN_SESSION_ID] = create_session.session_id
    session[:DOC_SCAN_SESSION_TOKEN] = create_session.client_session_token

    @iframe_url = "#{Yoti.configuration.doc_scan_api_endpoint}/web/index.html?sessionID=#{create_session.session_id}&sessionToken=#{create_session.client_session_token}"
  end

  #
  # Retrieve Session
  #
  def success
    @session_result = Yoti::DocScan::Client.get_session(session[:DOC_SCAN_SESSION_ID])
    render 'success'
  end

  #
  # Get Media
  #
  def media
    media_id = request.query_parameters[:mediaId]

    media = Yoti::DocScan::Client.get_media_content(session[:DOC_SCAN_SESSION_ID], media_id)

    if media.nil?
      head :no_content
    else
      render body: media.content, content_type: media.mime_type
    end
  end

  #
  # Error Page
  #
  def error
    @error = if request.query_parameters[:yotiErrorCode].nil?
               'An unknown error occurred'
             else
               "Error Code: #{request.query_parameters[:yotiErrorCode]}"
             end

    render 'error'
  end

  #
  # Privacy Policy Page
  #
  def privacy; end
end
