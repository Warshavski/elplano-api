require 'rails_helper'

describe Api::V1::UsersController do
  include_context 'shared auth'

  describe '#show' do
    subject { get '/api/v1/me', headers: auth_header }

    before(:each) { subject }

    context 'anonymous user' do
      let(:auth_header) { nil }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq('') }
    end

    context 'authenticated user' do
      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]

      it 'returns token owner' do
        actual_username = body_as_json[:data][:attributes][:username]
        expected_username = user.username

        expect(actual_username).to eq(expected_username)
      end
    end
  end
end
