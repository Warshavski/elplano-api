# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lecturers management', type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/lecturers' }
  let(:resource_endpoint) { "#{base_endpoint}/#{lecturer.id}" }

  let_it_be(:student)   { create(:student, :group_supervisor, user: user) }
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

    context 'student without group' do
      let_it_be(:student) { create(:student, user: user) }

      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data).to eq([]) }
    end

    context 'unsorted lecturers collection' do
      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(5) }
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[avatar first_name last_name patronymic created_at updated_at],
                     %w[courses]

    it 'returns correct expected data' do
      actual_title = json_data.dig(:attributes, :first_name).downcase
      expected_title = lecturer.first_name

      expect(actual_title).to eq(expected_title)
    end

    context 'not valid request' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'group owner' do
      it { expect(response).to have_http_status(:created) }

      it { expect(json_data['type']).to eq('lecturer') }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[avatar first_name last_name patronymic created_at updated_at],
                       %w[courses]

      it 'returns created model' do
        actual_title = json_data.dig(:attributes, :first_name)
        expected_title = lecturer_params[:attributes][:first_name]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'request errors examples'
    end

    context 'avatar' do
      let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
      let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

      let(:request_params) do
        core_params = build(:lecturer_params)

        core_params[:attributes].merge!(avatar: metadata.to_json)

        { data: core_params }
      end

      it { expect(response).to have_http_status(:created) }

      context 'invalid avatar metadata' do
        let(:request_params) do
          core_params = build(:lecturer_params)

          core_params[:attributes].merge!(
            avatar: {
              id: "344f98a5e8c879851116c54e9eb5e610.jpg",
              storage:"cache",
              metadata:{
                filename:"KMZxXr_1.jpg",
                size:187165,
                mime_type:"image/jpeg"
              }
            }.to_json
          )
          { data: core_params }
        end

        it { expect(response).to have_http_status(:bad_request) }
      end
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

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'group owner' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('lecturer') }

      it 'updates a lecturer model' do
        actual_title = lecturer.reload.first_name
        expected_title = lecturer_params[:attributes][:first_name].downcase

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[avatar first_name last_name patronymic created_at updated_at],
                       %w[courses]

      include_examples 'request errors examples'

      context 'avatar' do
        let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
        let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

        let(:request_params) do
          core_params = build(:lecturer_params)

          core_params[:attributes].merge!(avatar: metadata.to_json)

          { data: core_params }
        end

        it { expect(response).to have_http_status(:ok) }

        context 'invalid avatar metadata' do
          let(:request_params) do
            core_params = build(:lecturer_params)

            core_params[:attributes].merge!(
              avatar: {
                id: "344f98a5e8c879851116c54e9eb5e610.jpg",
                storage:"cache",
                metadata:{
                  filename:"KMZxXr_1.jpg",
                  size:187165,
                  mime_type:"image/jpeg"
                }
              }.to_json
            )
            { data: core_params }
          end

          it { expect(response).to have_http_status(:bad_request) }
        end
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

      context 'response with errors' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it { expect(response).to have_http_status(:forbidden) }
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
