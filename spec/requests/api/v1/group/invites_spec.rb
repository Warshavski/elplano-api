# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Group::InvitesController, type: :request do
  include_context 'shared setup'

  let(:base)  { '/api/v1/group/invites' }

  let_it_be(:student)  { create(:student, user: user) }
  let_it_be(:group)    { create(:group, president: student, students: [student]) }

  let_it_be(:invite) { create(:invite, sender: student, group: group) }

  let(:invite_params) { build(:invite_params) }

  let(:request_params)          { { data: invite_params } }
  let(:invalid_request_params)  { { data: build(:invalid_invite_params) } }

  describe 'GET #index' do
    subject { get endpoint, headers: headers }

    let(:endpoint) { base }

    context 'N+1' do
      bulletify { subject }
    end

    context 'authorized' do
      before(:each) { subject }

      it {  expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(1) }
    end

    context 'unauthorized' do
      before { group.update!(president: create(:student, :president)) }

      it 'responds with 403 status code' do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    let(:endpoint) { "#{base}/#{invite.id}" }

    context 'authorized' do
      before(:each) { subject }

      context 'valid request' do
        it { expect(response).to have_http_status(:ok) }

        it { expect(json_data['type']).to eq('invite') }

        include_examples 'json:api examples',
                         %w[data],
                         %w[id type attributes relationships],
                         %w[email invitation_token status sent_at accepted_at created_at updated_at],
                         %w[sender recipient group]

        it 'returns correct expected data' do
          actual_token = json_data.dig(:attributes, :invitation_token)
          expected_token = invite.invitation_token

          expect(actual_token).to eq(expected_token)
        end
      end

      context 'not valid request' do
        let(:endpoint) { "#{base}/0" }

        it { expect(response).to have_http_status(:not_found) }

        it { expect(body_as_json['errors']).to_not be(nil) }
      end
    end

    context 'unauthorized' do
      before { group.update!(president: create(:student, :president)) }

      it 'responds with 403 status code' do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    subject { post endpoint, params: request_params, headers: headers }

    let(:endpoint) { base }

    context 'authorized' do
      before(:each) { subject }

      it { expect(response).to have_http_status(:created) }

      it { expect(json_data['type']).to eq('invite') }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[email invitation_token status sent_at accepted_at created_at updated_at],
                       %w[sender recipient group]

      it 'returns created model' do
        actual_title = json_data.dig(:attributes, :email)
        expected_title = invite_params[:attributes][:email]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'request errors examples'
    end

    context 'unauthorized' do
      before { group.update!(president: create(:student, :president)) }

      it 'responds with 403 status code' do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
