# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do
  include_context 'shared setup'

  let(:base)  { '/api/v1/invites' }

  let_it_be(:student) { create(:student, user: user) }
  let_it_be(:invite)  { create(:invite, :rnd_group, email: user.email) }

  let(:request_params) { { data: nil } }

  describe 'GET #index' do
    subject { get endpoint, headers: headers }

    let(:endpoint) { base }

    context 'N+1' do
      bulletify { subject }
    end

    context 'unsorted invites collection' do
      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(1) }
    end
  end

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    before(:each) { subject }

    context 'valid request' do
      let(:endpoint) { "#{base}/#{invite.invitation_token}" }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('invite') }

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[email invitation_token status sent_at accepted_at created_at updated_at],
                       %w[sender recipient group]

      it 'returns correct expected data' do
        actual_token = body_as_json[:data][:attributes][:invitation_token]
        expected_token = invite.invitation_token

        expect(actual_token).to eq(expected_token)
      end
    end

    context 'not valid request' do
      let(:endpoint) { "#{base}/wat_token" }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data).to be(nil) }
    end
  end

  describe 'PUT #update' do
    subject { put endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'valid request' do
      let(:endpoint) { "#{base}/#{invite.invitation_token}" }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('invite') }

      it 'updates an invite status' do
        actual_status = body_as_json['data']['attributes']['status']
        expected_status = 'accepted'

        expect(actual_status).to eq(expected_status)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[email invitation_token status sent_at accepted_at created_at updated_at],
                       %w[sender recipient group]
    end

    context 'not valid request' do
      let(:endpoint) { "#{base}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
