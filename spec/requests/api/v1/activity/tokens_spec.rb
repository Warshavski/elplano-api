# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Activity::EventsController, action: :request do
  include_context 'shared setup', :user

  let(:base_endpoint) { '/api/v1/activity/tokens' }

  subject { get endpoint, headers: headers }

 describe 'GET #index' do
    let(:endpoint) { base_endpoint }

    let(:tokens_list) { build_list(:active_token, 2) }

    before do
      allow(ActiveToken).to receive(:list).with(user).and_return(tokens_list)
    end

    context 'when user is authorized user' do
      context 'N+1' do
        bulletify { subject }
      end

      it 'is expected to respond with activity events data' do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_data.count).to eq(2)
      end

    end

    context 'when user is anonymous' do
      before { subject }

      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
