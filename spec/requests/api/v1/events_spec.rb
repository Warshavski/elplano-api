# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  include_context 'shared setup'

  let(:base_endpoint)     { '/api/v1/events' }
  let(:resource_endpoint) { "#{base_endpoint}/#{event.id}" }

  let_it_be(:student) { create(:student, :group_member, user: user) }
  let_it_be(:event)   { create(:event, title: 'some_new_event', creator: student) }

  let(:event_params)  { build(:event_params) }

  let(:request_params) { { event: event_params } }
  let(:invalid_request_params) { { event: build(:invalid_event_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:events) { create_list(:event, 2, creator: student) }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when no filter params are provided' do
      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(3) }
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('event') }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course]

    it 'returns correct expected data' do
      actual_title = json_data.dig(:attributes, :title)
      expected_title = event.title

      expect(actual_title).to eq(expected_title)
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:created) }

    it { expect(json_data['type']).to eq('event') }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course]

    it 'returns created model' do
      actual_title = json_data.dig(:attributes, :title)
      expected_title = event_params[:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'request errors examples'

    context 'when the event is created with reference to the course' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:event_params) do
        build(:event_params).merge(course_id: course.id)
      end

      it 'return created model with bound course' do
        actual_course_id = relationship_data(:course)[:id].to_i

        expect(actual_course_id).to eq(course.id)
      end
    end
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('event') }

    it 'updates a event model' do
      actual_title = event.reload.title
      expected_title = event_params[:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator course]

    include_examples 'request errors examples'

    context 'when the event is updated with reference to the course' do
      let_it_be(:course) { create(:course, group: student.group) }

      let(:event_params) do
        build(:event_params).merge(course_id: course.id)
      end

      it 'return created model with bound course' do
        actual_course_id = relationship_data(:course)[:id].to_i

        expect(actual_course_id).to eq(course.id)
      end
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete resource_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed event' do
      delete "#{base_endpoint}/wat_event?", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes event' do
      expect { delete resource_endpoint, headers: headers }.to change(Event, :count).by(-1)
    end
  end
end
