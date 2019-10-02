# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AccomplishmentsController, type: :request do
  include_context 'shared setup'

  let_it_be(:student)     { create(:student, :group_supervisor, user: user) }
  let_it_be(:course)      { create(:course, group: student.group) }
  let_it_be(:assignment)  { create(:assignment, author: student, course: course) }

  let(:base_endpoint)     { '/api/v1/assignments' }
  let(:resource_endpoint) { "#{base_endpoint}/#{assignment.id}/accomplishment" }

  let(:file) { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:metadata) { AvatarUploader.new(:cache).upload(file) }

  let(:request_params) do
    { accomplishment: { attachments: [metadata.to_json]  } }
  end

  describe 'POST #create' do
    subject { post resource_endpoint, headers: headers, params: request_params }

    it 'creates an accomplishment for assignment' do
      expect { subject }.to change(Accomplishment, :count).by(1)
    end

    it 'responds with appropriate status and format' do
      subject

      expect(response).to have_http_status(:created)
      expect(body_as_json.keys).to eq(['meta'])
    end

    context 'when assignment is not exists' do
      it 'responds with a 404 status not existed assignment' do
        post "#{base_endpoint}/0/accomplishment", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete resource_endpoint, headers: headers }

    it 'responds with a 404 status not existed assignment' do
      subject

      expect(response).to have_http_status(:not_found)
    end

    context 'when accomplishment is exists' do
      let_it_be(:accomplishment) do
        create(:accomplishment, student: student, assignment: assignment)
      end

      it 'responds with a 204 status' do
        subject

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes assignment' do
        expect { subject }.to change(Accomplishment, :count).by(-1)
      end

      it 'responds with a 404 status not existed assignment' do
        delete "#{base_endpoint}/0/accomplishment", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
