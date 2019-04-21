require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  include_context 'shared setup'

  describe '#show' do
    subject { get '/api/v1/user', headers: headers }

    before(:each) { subject }

    context 'anonymous user' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq("{\"errors\":[{\"status\":401,\"title\":\"Authorization error\",\"detail\":\"Invalid authorization token\",\"source\":{\"pointer\":\"Authorization Header\"}}]}") }
    end

    context 'authenticated user' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('user') }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]

      it 'returns token owner' do
        actual_username = json_data.dig(:attributes, :username)
        expected_username = user.username

        expect(actual_username).to eq(expected_username)
      end
    end
  end
end
