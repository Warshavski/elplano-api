# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Group::CoursesController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/group/courses' }
  let(:resource_endpoint) { "#{base_endpoint}/#{course.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:course)  { create(:course, title: 'some new course', group: student.group) }

  let(:course_params) { build(:course_params) }

  let(:request_params)          { { course: course_params } }
  let(:invalid_request_params)  { { course: build(:invalid_course_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:courses) { create_list(:course, 2, group: student.group) }

    context 'N+1' do
      bulletify { subject }
    end

    before(:each) { subject }

    context 'when current user is a student without group' do
      let!(:user)  { create(:user) }
      let!(:token) { create(:token, resource_owner_id: user.id) }

      it 'is expected to return empty data' do
        expect(response).to have_http_status(:ok)
        expect(json_data).to eq([])
      end
    end

    context 'when no filter or sort params are present' do
      it 'is expected to return all courses' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to be(3)
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'is expected to return requested course data' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('course')

      actual_title = json_data.dig(:attributes, :title).downcase
      expected_title = course.title

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title active created_at updated_at],
                     %w[lecturers]

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

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
                       %w[title active created_at updated_at],
                       %w[lecturers]

      it 'returns created course entity' do
        actual_title = json_data.dig(:attributes, :title).downcase
        expected_title = course_params[:title].downcase

        expect(actual_title).to eq(expected_title)
      end

      context 'when the course is created with reference to the lecturer' do
        let_it_be(:lecturer) { create(:lecturer, group: student.group) }

        let(:course_params) do
          build(:course_params).merge(lecturer_ids: [lecturer.id])
        end

        it 'returns created course entity with bound lecturer' do
          actual_lecturer_ids = relationship_data(:lecturers).map { |l| l[:id].to_i }

          expect(actual_lecturer_ids).to include(lecturer.id)
        end
      end

      include_examples 'request errors examples'
    end

    context 'when user is a regular group member' do
      let!(:group)  { create(:group, students: [user.student]) }
      let!(:user)   { create(:user, :student) }
      let!(:token)  { create(:token, resource_owner_id: user.id) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      it 'updates a course model' do
        expect(response).to have_http_status(:ok)

        actual_title = course.reload.title
        expected_title = course_params[:title].downcase

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[title active created_at updated_at],
                       %w[lecturers]

      include_examples 'request errors examples'

      context 'when updates with a lecturer' do
        let(:lecturer) { create(:lecturer, group: student.group) }

        let(:course_params) do
          build(:course_params).merge(lecturer_ids: [lecturer.id])
        end

        it 'return created model with bound lecturer' do
          actual_lecturer_ids = relationship_data(:lecturers).map { |l| l[:id].to_i }

          expect(actual_lecturer_ids).to include(lecturer.id)
        end
      end

      context 'when request params are not valid' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'when user is a regular group member' do
      let!(:user)  { create(:user) }
      let!(:token) { create(:token, resource_owner_id: user.id) }

      let(:student) { create(:student, :group_member, user: user) }
      let(:course)  { create(:course, title: 'some new course', group: student.group) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'when only deactivation is performed' do
      let(:request_params) { { course: { active: false } } }

      it 'is expected to deactivate the course' do
        expect(json_data.dig(:attributes, :active)).to be(false)
        expect(course.reload.active).to be(false)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is a group owner' do
      it 'responds with a 204 status' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:no_content)
      end

      it 'responds with a 404 status not existed course' do
        delete "#{base_endpoint}/wat_course?", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'deletes course' do
        expect { delete resource_endpoint, headers: headers }.to change(Course, :count).by(-1)
      end
    end

    context 'when user is a regular group member' do
      let!(:user)  { create(:user) }
      let!(:token) { create(:token, resource_owner_id: user.id) }

      let(:student) { create(:student, :group_member, user: user) }
      let(:course)  { create(:course, title: 'some new course', group: student.group) }

      it 'responds with 403 - forbidden' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
