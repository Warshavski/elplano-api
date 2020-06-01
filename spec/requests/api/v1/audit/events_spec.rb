# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Audit::EventsController, type: :request do
  include_context 'shared setup', :user

  let(:base_endpoint) { '/api/v1/audit/events' }

  let_it_be(:authentication_event) do
    create(:audit_event, :authentication, author: user, entity: user)
  end

  let_it_be(:permanent_event) do
    create(:audit_event, :permanent_action, author: user, entity: user)
  end

  let_it_be(:events) { [authentication_event, permanent_event] }

  subject { get endpoint, headers: headers, params: params }

  let(:params) { {} }

  before(:each) { subject }

  describe 'GET #index' do
    let(:endpoint) { base_endpoint }

    context 'when user is authorized user' do
      context 'N+1' do
        bulletify { subject }
      end

      it 'is expected to respond with audit events data' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to eq(2)
      end

      context 'when type filter is set' do
        let(:params) do
          {
            filter: { type: 'authentication' }
          }
        end

        it 'is expected to respond with events filtered by type' do
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
