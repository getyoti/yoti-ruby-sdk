# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class ResourceContainer
          # @return [Array<IdDocumentResourceResponse>]
          attr_reader :id_documents

          # @return [Array<SupplementaryDocumentResourceResponse>]
          attr_reader :supplementary_documents

          # @return [Array<LivenessResourceResponse>]
          attr_reader :liveness_capture

          #
          # @param [Hash] resources
          #
          def initialize(resources)
            @id_documents = parse_id_documents(resources)
            @supplementary_documents = parse_supplementary_documents(resources)

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

          #
          # @return [Array<ZoomLivenessResourceResponse>]
          #
          def zoom_liveness_resources
            @liveness_capture.select { |resource| resource.is_a?(ZoomLivenessResourceResponse) }
          end

          private

          def parse_id_documents(resources)
            return [] if resources['id_documents'].nil?

            Validation.assert_is_a(Array, resources['id_documents'], 'id_documents')
            resources['id_documents'].map do |resource|
              IdDocumentResourceResponse.new(resource)
            end
          end

          def parse_supplementary_documents(resources)
            return [] if resources['supplementary_documents'].nil?

            Validation.assert_is_a(Array, resources['supplementary_documents'], 'supplementary_documents')
            resources['supplementary_documents'].map do |resource|
              SupplementaryDocumentResourceResponse.new(resource)
            end
          end
        end
      end
    end
  end
end
