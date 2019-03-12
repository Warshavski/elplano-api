# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses management', type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/courses' }
  let(:resource_endpoint) { "#{base_endpoint}/#{course.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:course)  { create(:course, title: 'some new course', group: student.group) }

  let(:course_params)  { build(:course_params) }

  let(:request_params) { { data: course_params } }
  let(:invalid_request_params) { { data: build(:invalid_course_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:courses) { create_list(:course, 4, group: student.group) }

    context 'N+1' do
      bulletify { subject }
    end

    context 'student without group' do
      let_it_be(:student) { create(:student, user: user) }

      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json['data']).to eq([]) }
    end

    context 'unsorted courses collection' do
      before(:each) { subject }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(JSON.parse(response.body)['data'].count).to be(5)
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title created_at updated_at],
                     %w[lecturers]

    it 'returns correct expected data' do
      actual_title = body_as_json[:data][:attributes][:title].downcase
      expected_title = course.title

      expect(actual_title).to eq(expected_title)
    end

    context 'not valid request' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

      it 'returns 404 response on not existed course' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'group owner' do
      it 'responds with a 201 status' do
        expect(response).to have_http_status(:created)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[title created_at updated_at],
                       %w[lecturers]

      it 'returns created model' do
        actual_title = body_as_json[:data][:attributes][:title].downcase
        expected_title = course_params[:attributes][:title].downcase

        expect(actual_title).to eq(expected_title)
      end

      context 'lecturer binding' do
        let_it_be(:lecturer) { create(:lecturer, group: student.group) }

        let(:course_params) do
          lecturer_params = {
            relationships: {
              lecturers: {
                data: [{ id: lecturer.id, type: 'lecturer' }]
              }
            }
          }

          build(:course_params).merge(lecturer_params)
        end

        it 'return created model with bound lecturer' do
          actual_lecturer_ids = relationship_data(:lecturers).map { |l| l[:id].to_i }

          expect(actual_lecturer_ids).to include(lecturer.id)
        end
      end

      include_examples 'request errors examples'
    end

    context 'regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it 'responds with 403 - forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'group owner' do
      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates a course model' do
        actual_title = course.reload.title
        expected_title = course_params[:attributes][:title].downcase

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[title created_at updated_at],
                       %w[lecturers]

      include_examples 'request errors examples'

      context 'lecturer binding' do
        let_it_be(:lecturer) { create(:lecturer, group: student.group) }

        let(:course_params) do
          lecturer_params = {
            relationships: {
              lecturers: {
                data: [{ id: lecturer.id, type: 'lecturer' }]
              }
            }
          }

          build(:course_params).merge(lecturer_params)
        end

        it 'return created model with bound lecturer' do
          actual_lecturer_ids = relationship_data(:lecturers).map { |l| l[:id].to_i }

          expect(actual_lecturer_ids).to include(lecturer.id)
        end
      end

      context 'response with errors' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_course?" }

        it 'responds with a 404 status not existed course' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it 'responds with 403 - forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'group owner' do
      it 'responds with a 204 status' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:no_content)
      end

      it 'responds with a 404 status not existed course' do
        delete "#{base_endpoint}/wat_course?", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'deletes publisher' do
        expect { delete resource_endpoint, headers: headers }.to change(Course, :count).by(-1)
      end
    end

    context 'regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it 'responds with 403 - forbidden' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
