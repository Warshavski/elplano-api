# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events management', type: :request do
  let(:base_url)  { '/api/v1/me/events' }
  let(:event_url) { "#{base_url}/#{event.id}" }

  let(:user)        { create(:user) }
  let(:token)       { create(:token, resource_owner_id: user.id) }
  let(:auth_header) { { 'Authorization' => "Bearer #{token.token}"} }

  let!(:student) { create(:student, user: user) }

  let(:event)         { create(:event, title: 'some_new_event', creator: student) }
  let(:event_params)  { build(:event_params) }

  describe 'GET #index' do
    let!(:events) { create_list(:event, 10, creator: student) }

    before(:each) { get base_url, headers: auth_header }

    context 'unsorted events collection' do
      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(JSON.parse(response.body)['data'].count).to be(10)
      end

      it 'responds with json-api format' do
        actual_keys = body_as_json[:data].first.keys

        expect(response.body).to look_like_json
        expect(actual_keys).to match_array(%w[id type attributes relationships])
      end

      it 'returns with correct attributes' do
        actual_keys = body_as_json[:data].first[:attributes].keys
        expected_keys = %w[
          title
          description
          status
          created_at
          updated_at
          start_at
          end_at
          timezone
          recurrence
        ]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'GET #show' do
    before(:each) { get event_url, headers: auth_header }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'responds with root json-api keys' do
      expect(body_as_json.keys).to match_array(%w[data])
    end

    it 'responds with json-api format' do
      actual_keys = body_as_json[:data].keys

      expect(response.body).to look_like_json
      expect(actual_keys).to match_array(%w[id type attributes relationships])
    end

    it 'responds with correct relationships' do
      actual_keys = body_as_json[:data][:relationships].keys

      expect(actual_keys).to match_array(%w[creator])
    end

    it 'returns correct data format' do
      actual_keys = body_as_json[:data][:attributes].keys
      expected_keys = %w[
        title
        description
        status
        created_at
        updated_at
        start_at
        end_at
        timezone
        recurrence
      ]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns correct expected data' do
      expect(body_as_json[:data][:attributes][:title]).to eq(event.title)
    end

    context 'requests with errors' do
      it 'returns 404 response on not existed event' do
        get "#{base_url}/wat_event?", headers: auth_header

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    before(:each) { post base_url, params: { data: event_params }, headers: auth_header }

    it 'responds with a 201 status' do
      expect(response).to have_http_status(:created)
    end

    it 'responds with json-api format' do
      actual_keys = body_as_json[:data].keys

      expect(response.body).to look_like_json
      expect(actual_keys).to match_array(%w[id type attributes relationships])
    end

    it 'returns correct data format' do
      actual_keys = body_as_json[:data][:attributes].keys
      expected_keys = %w[
        title
        description
        status
        created_at
        updated_at
        start_at
        end_at
        timezone
        recurrence
      ]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns created model' do
      expect(body_as_json[:data][:attributes][:title]).to eq(event_params[:attributes][:title])
    end

    context 'event presence' do
      it {
        expect { post base_url, params: { data: event_params }, headers: auth_header }.to change(Event, :count).by(1)
      }
    end

    context 'request with not valid params' do
      it 'responds with a 400 status on not presented params' do
        post base_url, params: nil, headers: auth_header

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on not request without params' do
        post base_url, headers: auth_header

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on invalid params' do
        event_params[:attributes][:title] = nil
        post base_url, params: { data: event_params }, headers: auth_header

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    before(:each) { put event_url, params: { data: event_params }, headers: auth_header }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'updates a event model' do
      expect(event.reload.title).to eq(event_params[:attributes][:title])
    end

    it 'responds with json-api format' do
      actual_keys = body_as_json[:data].keys

      expect(response.body).to look_like_json
      expect(actual_keys).to match_array(%w[id type attributes relationships])
    end

    it 'returns correct data format' do
      actual_keys = body_as_json[:data][:attributes].keys
      expected_keys = %w[
        title
        description
        status
        created_at
        updated_at
        start_at
        end_at
        timezone
        recurrence
      ]

      expect(actual_keys).to match_array(expected_keys)
    end

    context 'response with errors' do
      it 'responds with a 404 status not existed event' do
        put "#{base_url}/wat_event?", params: { event: event_params }, headers: auth_header

        expect(response).to have_http_status(:not_found)
      end

      it 'responds with a 400 status on request with empty params' do
        put event_url, params: nil, headers: auth_header

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on request without params' do
        put event_url, headers: auth_header

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on request with not valid params' do
        event_params[:attributes][:title] = nil
        put event_url, params: { data: event_params }, headers: auth_header

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete event_url, headers: auth_header

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed event' do
      delete "#{base_url}/wat_event?", headers: auth_header

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes publisher' do
      expect { delete event_url, headers: auth_header }.to change(Event, :count).by(0)
    end
  end
end
