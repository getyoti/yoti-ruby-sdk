# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class ResourceContainer
          attr_reader :id_documents, :liveness_capture

          def initialize(resources)
            if resources['id_documents'].nil?
              @id_documents = []
            else
              Validation.assert_is_a(Array, resources['id_documents'], 'id_documents')
              @id_documents = resources['id_documents'].map { |resource| IdDocumentResourceResponse.new(resource) }
            end

            if resources['liveness_capture'].nil?
              @liveness_capture = []
            else
              Validation.assert_is_a(Array, resources['liveness_capture'], 'liveness_capture')
              @liveness_capture = resources['liveness_capture'].map do |resource|
                case resource['liveness_type']
                when Constants::ZOOM
                  ZoomLivenessResourceResponse.new(resource)
                else
                  LivenessResourceResponse.new(resource)
                end
              end
            end
          end

          def zoom_liveness_resources
            @liveness_capture.filter { |resource| resource.is_a?(ZoomLivenessResourceResponse) }
          end
        end
      end
    end
  end
end
