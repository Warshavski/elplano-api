# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events management', type: :request do
  include_context 'shared setup'

  let(:base_url)  { '/api/v1/events' }
  let(:event_url) { "#{base_url}/#{event.id}" }

  let!(:student) { create(:student, user: user) }

  let(:event)         { create(:event, title: 'some_new_event', creator: student) }
  let(:event_params)  { build(:event_params) }

  let(:request_params) { { data: event_params } }
  let(:invalid_request_params) { { data: build(:invalid_event_params) } }

  describe 'GET #index' do
    subject { get base_url, headers: headers }

    let!(:events) { create_list(:event, 10, creator: student) }

    before(:each) { subject }

    context 'unsorted events collection' do
      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(JSON.parse(response.body)['data'].count).to be(10)
      end
    end
  end

  describe 'GET #show' do
    subject { get event_url, headers: headers }

    before(:each) { subject }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator]

    it 'returns correct expected data' do
      actual_title = body_as_json[:data][:attributes][:title]
      expected_title = event.title

      expect(actual_title).to eq(expected_title)
    end

    context 'not valid request' do
      let(:event_url) { "#{base_url}/wat_event?" }

      it 'returns 404 response on not existed event' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    subject { post base_url, params: request_params, headers: headers }

    before(:each) { subject }

    it 'responds with a 201 status' do
      expect(response).to have_http_status(:created)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator]

    it 'returns created model' do
      actual_title = body_as_json[:data][:attributes][:title]
      expected_title = event_params[:attributes][:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'request errors examples'
  end

  describe 'PUT #update' do
    subject { put event_url, params: request_params, headers: headers }

    before(:each) { subject }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'updates a event model' do
      actual_title = event.reload.title
      expected_title = event_params[:attributes][:title]

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title description status start_at end_at timezone recurrence created_at updated_at],
                     %w[creator]

    include_examples 'request errors examples'

    context 'response with errors' do
      let(:event_url) { "#{base_url}/wat_event?" }

      it 'responds with a 404 status not existed event' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete event_url, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed event' do
      delete "#{base_url}/wat_event?", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes publisher' do
      expect { delete event_url, headers: headers }.to change(Event, :count).by(0)
    end
  end
end
