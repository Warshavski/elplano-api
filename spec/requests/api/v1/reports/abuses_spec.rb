# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reports::AbusesController, type: :request do
  include_context 'shared setup'

  describe 'POST #create' do
    subject { post '/api/v1/reports/abuses', params: request_params, headers: headers }

    let_it_be(:reported_user) { create(:user) }

    let(:request_params) do
      {
        report: {
          user_id: reported_user.id,
          message: 'Bang! Report'
        }
      }
    end

    let(:invalid_request_params) do
      {
        report: {
          user_id: 0,
          message: nil
        }
      }
    end

    context 'response' do
      before(:each) { subject }

      it 'is expected to respond with meta' do
        expect(response).to have_http_status(:created)

        expect(body_as_json.keys).to match_array(['meta'])
      end

      include_examples 'request errors examples'
    end

    context 'report creation' do
      it { expect { subject }.to change(AbuseReport, :count).by(1) }
    end
  end
end
