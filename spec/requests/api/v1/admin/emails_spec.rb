# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Admin::EmailsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:random_user) { create(:user, confirmation_token: 'wat', confirmed_at: nil) }

  describe 'POST #create' do
    let_it_be(:endpoint) { '/api/v1/admin/emails' }

    let_it_be(:mailing_params) do
      { type: 'confirmation', user_id: random_user.id }
    end

    context 'when request params are valid' do
      subject { post endpoint, headers: headers, params: { mailing: mailing_params } }

      context 'request performing' do
        before(:each) { subject }

        it 'is expected to respond with meta' do
          expect(response).to have_http_status(:created)

          expect(body_as_json.keys).to match_array(['meta'])
        end
      end

      context 'email sending' do
        it 'enqueues confirmation email send' do
          expected_params = [
            'Devise::Mailer',
            'confirmation_instructions',
            'deliver_now',
            random_user,
            'wat',
            {}
          ]

          expect { subject }.to(have_enqueued_job(ActionMailer::DeliveryJob).with(*expected_params))
        end
      end
    end

    context 'when request params are not valid' do
      context 'when no params are not provided' do
        before(:each) { post endpoint, headers: headers }

        it { expect(response).to have_http_status(:bad_request) }
      end

      context 'when invalid params are provided' do
        before(:each) do
          post endpoint, headers: headers, params: { mailing: { type: 'wat' } }
        end

        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end
end
