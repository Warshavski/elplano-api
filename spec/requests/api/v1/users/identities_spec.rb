# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::IdentitiesController, type: :request do
  include_context 'shared setup'

  describe 'GET #index' do
    subject { get '/api/v1/users/identities', headers: headers }

    let_it_be(:identities) do
      [
        create(:identity, provider: :google, user: user),
        create(:identity, provider: :yandex, user: user)
      ]
    end

    before(:each) { subject }

    context 'when user is authorized user' do
      it 'is expected to respond with entities of the identity type' do
        expect(response).to have_http_status(:ok)
        expect(json_data.count).to eq(2)

        json_data.each do |data|
          expect(data['type']).to eq('identity')
        end
      end

      it 'is expected to respond with identities with expected attributes' do
        entity = json_data.first

        expected_attributes = %w[provider created_at updated_at]

        expect(entity[:attributes].keys).to match_array(expected_attributes)
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete "/api/v1/users/identities/#{identity_id}", headers: headers }

    let_it_be(:identity) { create(:identity, provider: :google, user: user) }
    let_it_be(:identity_id) { identity.id }

    context 'when user is authorized user' do
      it 'is expected to respond with a 204 status' do
        subject

        expect(response).to have_http_status(:no_content)
      end

      it { expect { subject }.to change(Identity, :count).by(-1) }

      context 'when identity is not exist' do
        let_it_be(:identity_id) { 0 }

        it 'is expected to respond with a 404 status not existed identity' do
          subject

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it 'is expected to respond with unauthorized' do
        subject

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
