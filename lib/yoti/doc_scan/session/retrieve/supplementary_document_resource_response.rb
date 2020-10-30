# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class SupplementaryDocumentResourceResponse < ResourceResponse
          # @return [String]
          attr_reader :document_type

          # @return [String]
          attr_reader :issuing_country

          # @return [Array<PageResponse>]
          attr_reader :pages

          # @return [DocumentFieldsResponse]
          attr_reader :document_fields

          # @return [FileResponse]
          attr_reader :document_file

          #
          # @param [Hash] resource
          #
          def initialize(resource)
            super(resource)

            Validation.assert_is_a(String, resource['document_type'], 'document_type', true)
            @document_type = resource['document_type']

            Validation.assert_is_a(String, resource['issuing_country'], 'issuing_country', true)
            @issuing_country = resource['issuing_country']

            if resource['pages'].nil?
              @pages = []
            else
              Validation.assert_is_a(Array, resource['pages'], 'pages')
              @pages = resource['pages'].map { |page| PageResponse.new(page) }
            end

            @document_fields = DocumentFieldsResponse.new(resource['document_fields']) unless resource['document_fields'].nil?

            @document_file = FileResponse.new(resource['file']) unless resource['file'].nil?
          end

          #
          # @return [Array<SupplementaryDocumentTextExtractionTaskResponse>]
          #
          def text_extraction_tasks
            @tasks.select { |task| task.is_a?(SupplementaryDocumentTextExtractionTaskResponse) }
          end
        end
      end
    end
  end
end
