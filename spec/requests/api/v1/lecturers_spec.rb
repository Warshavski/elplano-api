# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lecturers management', type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/lecturers' }
  let(:resource_endpoint) { "#{base_endpoint}/#{lecturer.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:lecturer)  { create(:lecturer, group: student.group) }

  let(:lecturer_params)  { build(:lecturer_params) }

  let(:request_params) { { data: lecturer_params } }
  let(:invalid_request_params) { { data: build(:invalid_lecturer_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:lecturers) { create_list(:lecturer, 4, group: student.group) }

    context 'N+1' do
      bulletify { subject }
    end

    context 'unsorted lecturers collection' do
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
                     %w[first_name last_name patronymic created_at updated_at],
                     %w[courses]

    it 'returns correct expected data' do
      actual_title = body_as_json[:data][:attributes][:first_name].downcase
      expected_title = lecturer.first_name

      expect(actual_title).to eq(expected_title)
    end

    context 'not valid request' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

      it 'returns 404 response on not existed lecturer' do
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
                       %w[first_name last_name patronymic created_at updated_at],
                       %w[courses]

      it 'returns created model' do
        actual_title = body_as_json[:data][:attributes][:first_name]
        expected_title = lecturer_params[:attributes][:first_name]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'request errors examples'
    end

    context 'course binding' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:lecturer_params) do
        course_params = {
          relationships: {
            courses: {
              data: [{ id: course.id, type: 'course' }]
            }
          }
        }

        build(:lecturer_params).merge(course_params)
      end

      it 'return created model with bound course' do
        actual_course_ids = relationship_data(:courses).map { |c| c[:id].to_i }

        expect(actual_course_ids).to include(course.id)
      end
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

      it 'updates a lecturer model' do
        actual_title = lecturer.reload.first_name
        expected_title = lecturer_params[:attributes][:first_name].downcase

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[first_name last_name patronymic created_at updated_at],
                       %w[courses]

      include_examples 'request errors examples'

      context 'course binding' do
        let_it_be(:course) { create(:course, group: student.group) }

        let(:lecturer_params) do
          course_params = {
            relationships: {
              courses: {
                data: [{ id: course.id, type: 'course' }]
              }
            }
          }

          build(:lecturer_params).merge(course_params)
        end

        it 'return created model with bound course' do
          actual_course_ids = relationship_data(:courses).map { |c| c[:id].to_i }

          expect(actual_course_ids).to include(course.id)
        end
      end

      context 'response with errors' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

        it 'responds with a 404 status not existed lecturer' do
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

      it 'responds with a 404 status not existed lecturer' do
        delete "#{base_endpoint}/wat_lecturer?", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'deletes publisher' do
        expect { delete resource_endpoint, headers: headers }.to change(Lecturer, :count).by(-1)
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
