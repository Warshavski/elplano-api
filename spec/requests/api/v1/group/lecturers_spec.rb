# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Group::LecturersController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/group/lecturers' }
  let(:resource_endpoint) { "#{base_endpoint}/#{lecturer.id}" }

  let_it_be(:student)   { create(:student, :group_supervisor, user: user) }
  let_it_be(:lecturer)  { create(:lecturer, group: student.group) }

  let(:lecturer_params)  { build(:lecturer_params) }

  let(:request_params)          { { lecturer: lecturer_params } }
  let(:invalid_request_params)  { { lecturer: build(:invalid_lecturer_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:lecturers) { create_list(:lecturer, 2, group: student.group) }

    context 'N+1' do
      bulletify { subject }
    end

    before(:each) { subject }

    context 'when user is a student without group' do
      let!(:user)  { create(:user, :student) }
      let!(:token) { create(:token, resource_owner_id: user.id) }

      it 'is expected to respond with empty data' do
        expect(response).to have_http_status(:ok)

        expect(json_data).to eq([])
      end
    end

    context 'when no sort or filter params are present' do
      before(:each) { subject }

      it 'expected to respond with lecturers collection' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to be(3)
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with lecturer entity' do
      expect(response).to have_http_status(:ok)

      actual_title = json_data.dig(:attributes, :first_name).downcase
      expected_title = lecturer.first_name

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[avatar first_name last_name patronymic email phone active created_at updated_at],
                     %w[courses]

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[avatar first_name last_name patronymic email phone active created_at updated_at],
                       %w[courses]

      it 'is expected to respond with created lecturer entity' do
        expect(response).to have_http_status(:created)

        expect(json_data['type']).to eq('lecturer')

        actual_title = json_data.dig(:attributes, :first_name)
        expected_title = lecturer_params[:first_name]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'request errors examples'
    end

    context 'when avatar presented' do
      let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
      let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

      let(:request_params) do
        core_params = build(:lecturer_params)

        core_params.merge!(avatar: metadata.to_json)

        { lecturer: core_params }
      end

      it { expect(response).to have_http_status(:created) }

      context 'when avatar metadata is not valid' do
        let(:request_params) do
          core_params = build(:lecturer_params)

          core_params.merge!(
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

          { lecturer: core_params }
        end

        it { expect(response).to have_http_status(:bad_request) }
      end
    end

    context 'when the lecturer is created with reference to the course' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:lecturer_params) do
        build(:lecturer_params).merge(course_ids: [course.id])
      end

      it 'return created lecturer entity with reference to the course' do
        actual_course_ids = relationship_data(:courses).map { |c| c[:id].to_i }

        expect(actual_course_ids).to include(course.id)
      end
    end

    context 'when user is a regular group member' do
      let!(:user)  { create(:user, :student) }
      let!(:token) { create(:token, resource_owner_id: user.id) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when user is a group owner' do
      it 'is expected to respond with updated lecturer entity' do
        expect(response).to have_http_status(:ok)

        expect(json_data['type']).to eq('lecturer')

        actual_title = lecturer.reload.first_name
        expected_title = lecturer_params[:first_name].downcase

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[avatar first_name last_name patronymic email phone active created_at updated_at],
                       %w[courses]

      include_examples 'request errors examples'

      context 'when avatar is updated' do
        let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
        let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

        let(:request_params) do
          core_params = build(:lecturer_params)

          core_params.merge!(avatar: metadata.to_json)

          { lecturer: core_params }
        end

        it { expect(response).to have_http_status(:ok) }

        context 'when avatar metadata is not valid' do
          let(:request_params) do
            core_params = build(:lecturer_params)

            core_params.merge!(
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

            { lecturer: core_params }
          end

          it { expect(response).to have_http_status(:bad_request) }
        end
      end

      context 'when the lecturer is updated with reference to the course' do
        let_it_be(:course) { create(:course, group: student.group) }

        let(:lecturer_params) do
          build(:lecturer_params).merge(course_ids: [course.id])
        end

        it 'return updated lecturer entity with reference to the course' do
          actual_course_ids = relationship_data(:courses).map { |c| c[:id].to_i }

          expect(actual_course_ids).to include(course.id)
        end
      end

      context 'when only deactivation is performed' do
        let_it_be(:request_params) { { lecturer: { active: false } } }

        it { expect(json_data.dig(:attributes, :active)).to be(false) }

        it { expect(lecturer.reload.active).to be(false) }
      end

      context 'when request params are not valid' do
        let(:resource_endpoint) { "#{base_endpoint}/wat_lecturer?" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'when user is a regular group member' do
      let!(:group)  { create(:group, students: [user.student]) }
      let!(:user)   { create(:user, :student) }
      let!(:token)  { create(:token, resource_owner_id: user.id) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is a group owner' do
      it 'is expected to respond with a 204 status' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:no_content)
      end

      it 'is expected to respond with a 404 status not existed lecturer' do
        delete "#{base_endpoint}/wat_lecturer?", headers: headers

        expect(response).to have_http_status(:not_found)
      end

      it 'is expected to delete lecturer' do
        expect { delete resource_endpoint, headers: headers }.to change(Lecturer, :count).by(-1)
      end
    end

    context 'when user is a regular group member' do
      let!(:group)  { create(:group, students: [user.student]) }
      let!(:user)   { create(:user, :student) }
      let!(:token)  { create(:token, resource_owner_id: user.id) }

      it 'is expected to respond with 403 - forbidden' do
        delete resource_endpoint, headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
