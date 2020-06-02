describe 'Yoti::DocScan::Session::Create::SessionSpecification' do
  it 'serializes correctly' do
    some_sdk_config = Yoti::DocScan::Session::Create::SdkConfig
                      .builder
                      .with_allows_camera
                      .build

    some_notification_config = Yoti::DocScan::Session::Create::NotificationConfig
                               .builder
                               .with_endpoint('some-endpoint')
                               .build

    some_text_extraction_task = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
                                .builder
                                .with_manual_check_fallback
                                .build

    some_face_match_check = Yoti::DocScan::Session::Create::RequestedFaceMatchCheck
                            .builder
                            .with_manual_check_fallback
                            .build

    some_liveness_check = Yoti::DocScan::Session::Create::RequestedLivenessCheck
                          .builder
                          .for_zoom_liveness
                          .build

    some_authenticity_check = Yoti::DocScan::Session::Create::RequestedDocumentAuthenticityCheck
                              .builder
                              .build

    some_document = Yoti::DocScan::Session::Create::RequiredIdDocument
                    .builder
                    .with_filter(
                      Yoti::DocScan::Session::Create::DocumentRestrictionsFilter
                      .builder
                      .for_whitelist
                      .build
                    )
                    .build

    spec = Yoti::DocScan::Session::Create::SessionSpecification
           .builder
           .with_client_session_token_ttl(30)
           .with_resources_ttl(10)
           .with_user_tracking_id('some-tracking-id')
           .with_sdk_config(some_sdk_config)
           .with_requested_check(some_face_match_check)
           .with_requested_check(some_liveness_check)
           .with_requested_check(some_authenticity_check)
           .with_requested_task(some_text_extraction_task)
           .with_notifications(some_notification_config)
           .with_required_document(some_document)
           .build

    expected = {
      client_session_token_ttl: 30,
      resources_ttl: 10,
      user_tracking_id: 'some-tracking-id',
      notifications: some_notification_config,
      requested_checks: [
        some_face_match_check,
        some_liveness_check,
        some_authenticity_check
      ],
      requested_tasks: [
        some_text_extraction_task
      ],
      sdk_config: some_sdk_config,
      required_documents: [
        some_document
      ]
    }

    expect(spec.to_json).to eql expected.to_json
  end
end
