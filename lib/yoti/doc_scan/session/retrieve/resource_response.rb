# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class ResourceResponse
          # @return [String]
          attr_reader :id

          # @return [Array<TaskResponse>]
          attr_reader :tasks

          #
          # @param [Hash] resource
          #
          def initialize(resource)
            Validation.assert_is_a(String, resource['id'], 'id', true)
            @id = resource['id']

            if resource['tasks'].nil?
              @tasks = []
            else
              Validation.assert_is_a(Array, resource['tasks'], 'tasks')
              @tasks = resource['tasks'].map do |task|
                case task['type']
                when Constants::ID_DOCUMENT_TEXT_DATA_EXTRACTION
                  TextExtractionTaskResponse.new(task)
                when Constants::SUPPLEMENTARY_DOCUMENT_TEXT_DATA_EXTRACTION
                  SupplementaryDocumentTextExtractionTaskResponse.new(task)
                else
                  TaskResponse.new(task)
                end
              end
            end
          end
        end
      end
    end
  end
end
