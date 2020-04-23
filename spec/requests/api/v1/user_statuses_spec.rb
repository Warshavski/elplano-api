# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::StatusesController, type: :request do
  include_context 'shared setup'

  let_it_be(:endpoint) { '/api/v1/status' }

  before(:each) { subject }

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    context 'when user is authenticated user' do
      context 'when user has defined status' do
        let_it_be(:status) { create(:user_status, user: user) }

        it 'is expected to respond with authenticated user status' do
          expect(response).to have_http_status(:ok)
          expect(json_data['type']).to eq('user_status')

          actual_message = json_data.dig(:attributes, :message)
          expected_message = user.status.message

          expect(actual_message).to eq(expected_message)
        end

        include_examples 'json:api examples',
                         %w[data],
                         %w[id type attributes],
                         %w[message emoji created_at updated_at]
      end

    end

    context 'when user has no defined status' do
      it 'is expected to respond with empty data' do
        expect(response).to have_http_status(:ok)
        expect(json_data).to eq(nil)
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'PATCH #update' do
    subject { put endpoint, headers: headers, params: request_params }

    let_it_be(:request_params) do
      {
        user_status: {
          message: Faker::Lorem.sentence,
          emoji: 'ribbon',
        }
      }
    end

    context 'when user has no defined status' do
      it 'is expected to create status for authenticated user' do
        expect(response).to have_http_status(:ok)

        actual_status = user.reload.status

        expect(actual_status.message).to eq(request_params.dig(:user_status, :message))
        expect(actual_status.emoji).to eq(request_params.dig(:user_status, :emoji))
      end
    end

    context 'when use has defined status' do
      let_it_be(:user_status) { create(:user_status, user: user) }

      it 'is expected to create status for authenticated user' do
        expect(response).to have_http_status(:ok)

        user_status.reload

        expect(user_status.message).to eq(request_params.dig(:user_status, :message))
        expect(user_status.emoji).to eq(request_params.dig(:user_status, :emoji))
      end
    end

    context 'when request params are not valid' do
      let_it_be(:request_params) do
        {
          user_status: {
            message: Faker::Lorem.paragraph(sentence_count: 20),
            emoji: Faker::SlackEmoji.emoji,
          }
        }
      end

      it 'is expected to respond with unprocessable entity error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete endpoint, headers: headers }

    context 'when user has no defined status' do
      it 'is expected to create status for authenticated user' do
        expect(response).to have_http_status(:no_content)

        expect(user.reload.status).to eq(nil)
      end
    end

    context 'when use has defined status' do
      let_it_be(:user_status) { create(:user_status, user: user) }

      it 'is expected to create status for authenticated user' do
        expect(response).to have_http_status(:no_content)

        expect(user.reload.status).to eq(nil)
        expect(UserStatus.exists?(user_status.id)).to be false
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
