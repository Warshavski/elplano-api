# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AssignmentsController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/assignments' }
  let(:resource_endpoint) { "#{base_endpoint}/#{assignment.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:course)  { create(:course, group: student.group) }

  let_it_be(:assignment) do
    create(:assignment, course: course, author: student)
  end

  let(:assignment_params) { build(:assignment_params) }

  let(:request_params) do
    { assignment: assignment_params.merge(course_id: course.id) }
  end

  let(:invalid_request_params) do
    { assignment: build(:invalid_assignment_params).merge(course_id: course.id) }
  end

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:assignments) { create_list(:assignment, 2, course: course, author: student) }

    context 'N+1' do
      bulletify { subject }
    end

    before(:each) { subject }

    context 'when no filter or sort params are presented' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(3) }

      it 'returns correctly formatted response' do
        assignment_data = json_data.first

        expect(assignment_data['type']).to eq('assignment')
        expect(assignment_data['attributes'].keys).to(
          match_array(%w[title description outdated expired_at created_at updated_at])
        )
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('assignment') }

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title description outdated expired_at created_at updated_at],
                     %w[course]

    it 'returns requested assignment entity' do
      actual_title = json_data.dig(:attributes, :title)
      expected_title = assignment.title

      expect(actual_title).to eq(expected_title)
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_assignment?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      it { expect(response).to have_http_status(:created) }

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[title description outdated expired_at created_at updated_at],
                       %w[course]

      it { expect(course.id.to_s).to eq(relationship_data(:course)[:id]) }

      it 'returns created course entity' do
        actual_title = json_data.dig(:attributes, :title)
        expected_title = assignment_params[:title]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'request errors examples'
    end

    context 'when user is a regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      it { expect(response).to have_http_status(:ok) }

      it 'updates a assignment model' do
        actual_title = assignment.reload.title
        expected_title = assignment_params[:title]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[title description outdated expired_at created_at updated_at],
                       %w[course]

      include_examples 'request errors examples'

      it { expect(course.id.to_s).to eq(relationship_data(:course)[:id]) }

      context 'when request params are not valid' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'when user is a regular group member' do
      let_it_be(:regular_student) do
        create(:student, group: student.group, user: user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is a group owner' do
      it 'responds with a 204 status' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:no_content)
      end

      it 'responds with a 404 status not existed assignment' do
        delete "#{base_endpoint}/0", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'deletes assignment' do
        expect { delete resource_endpoint, headers: headers }.to change(Assignment, :count).by(-1)
      end
    end

    context 'when user is a regular group member' do
      let_it_be(:regular_student) do
        create(:student, group: student.group, user: user)
      end

      it 'responds with 403 - forbidden' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
