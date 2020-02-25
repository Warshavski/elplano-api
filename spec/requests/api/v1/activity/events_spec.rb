# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Activity::EventsController, action: :request do
  include_context 'shared setup', :user

  let(:base_endpoint) { '/api/v1/activity/events' }

  let_it_be(:student)     { create(:student, user: user) }
  let_it_be(:assignment)  { create(:assignment, student: student) }

  let_it_be(:created_event) do
    create(:activity_event, :created, author: user, target: assignment)
  end

  let_it_be(:updated_event) do
    create(:activity_event, :updated, author: user, target: assignment)
  end

  let_it_be(:events) { [created_event, updated_event] }

  subject { get endpoint, headers: headers, params: params }

  let(:params) { {} }

  before(:each) { subject }

  describe 'GET #index' do
    let(:endpoint) { base_endpoint }

    context 'when user is authorized user' do
      context 'N+1' do
        bulletify { subject }
      end

      it 'is expected to respond with activity events data' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to eq(2)
      end

      context 'when action filter is set' do
        let(:params) do
          {
            filters: { action: 'created' }.to_json
          }
        end

        it 'is expected to respond with events filtered by action' do
          expect(response).to have_http_status(:ok)
          expect(json_data.count).to be(1)
        end
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
