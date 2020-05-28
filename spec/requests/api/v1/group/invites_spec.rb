# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Group::InvitesController, type: :request do
  include_context 'shared setup'

  let(:base)  { '/api/v1/group/invites' }

  let_it_be(:student)  { create(:student, user: user) }
  let_it_be(:group)    { create(:group, president: student, students: [student]) }

  let_it_be(:invite) { create(:invite, sender: student, group: group) }

  let(:invite_params) { build(:invite_params) }

  let(:request_params)          { { invite: invite_params } }
  let(:invalid_request_params)  { { invite: build(:invalid_invite_params) } }

  describe 'GET #index' do
    subject { get endpoint, headers: headers }

    let(:endpoint) { base }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when user is authorized' do
      before(:each) { subject }

      it 'is expected to respond with invites collection' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to be(1)
      end
    end

    context 'when user is unauthorized' do
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

    context 'when user is authorized' do
      before(:each) { subject }

      context 'when request params are valid' do
        it 'is expected to respond with invite entity' do
          expect(response).to have_http_status(:ok)

          expect(json_data['type']).to eq('invite')

          actual_token = json_data.dig(:attributes, :invitation_token)
          expected_token = invite.invitation_token

          expect(actual_token).to eq(expected_token)
        end

        include_examples 'json:api examples',
                         %w[data],
                         %w[id type attributes relationships],
                         %w[email invitation_token status sent_at accepted_at created_at updated_at],
                         %w[sender recipient group]
      end

      context 'when request params are not valid' do
        let(:endpoint) { "#{base}/0" }

        it 'is expected to respond with not found error' do
          expect(response).to have_http_status(:not_found)

          expect(body_as_json['errors']).to_not be(nil)
        end
      end
    end

    context 'when user is unauthorized' do
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

    context 'when user is authorized' do
      before(:each) { subject }

      it 'is expected to respond with created invite entity' do
        expect(response).to have_http_status(:created)

        expect(json_data['type']).to eq('invite')

        actual_title = json_data.dig(:attributes, :email)
        expected_title = invite_params[:email]

        expect(actual_title).to eq(expected_title)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[email invitation_token status sent_at accepted_at created_at updated_at],
                       %w[sender recipient group]

      include_examples 'request errors examples'
    end

    context 'when user is unauthorized' do
      before { group.update!(president: create(:student, :president)) }

      it 'is expected to respond with 403 status code' do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
