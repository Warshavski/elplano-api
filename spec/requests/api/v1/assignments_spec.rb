# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AssignmentsController, type: :request do
  include_context 'shared setup'

  let_it_be(:student)     { create(:student, :group_supervisor, user: user) }
  let_it_be(:course)      { create(:course, group: student.group) }
  let_it_be(:event)       { create(:event, eventable: student.group, creator: student) }
  let_it_be(:task)        { create(:task, event: event, author: student)}
  let_it_be(:assignment)  { create(:assignment, student: student, task: task) }

  let(:base_endpoint)     { '/api/v1/tasks' }
  let(:resource_endpoint) { "#{base_endpoint}/#{task.id}/assignment" }

  let(:file) { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:metadata) { AttachmentUploader.new(:cache).upload(file) }

  let(:request_params) do
    {
      assignment: {
        report: Faker::Lorem.paragraph(sentence_count: 3),
        accomplished: true,
        extra_links: (1..2).flat_map { Faker::Internet.url },
        attachments: [metadata.to_json]
      }
    }
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before { subject }

    it 'is expected to respond with assignment details' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('assignment')

      actual_report = json_data.dig(:attributes, :report)
      expected_report = assignment.report

      expect(actual_report).to eq(expected_report)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[accomplished report extra_links created_at updated_at]

    context 'when assignment is not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0/assignment" }

      it 'responds with a 404 status not existed assignment' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH #create' do
    subject { patch resource_endpoint, headers: headers, params: request_params }

    before { subject }

    it 'responds with updated assignment' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('assignment')

      %i[report accomplished extra_links].each do |attribute|
        actual_attribute = json_data.dig(:attributes, attribute)
        expected_attribute = request_params.dig(:assignment, attribute)

        expect(actual_attribute).to eq(expected_attribute)
      end
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[accomplished report extra_links created_at updated_at]

    context 'when assignment is not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0/assignment" }

      it 'responds with a 404 status not existed assignment' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
