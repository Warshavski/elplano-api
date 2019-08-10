# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::SettingsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/settings' }

  before(:each) { subject }

  describe 'PATCH #update' do
    subject { patch endpoint, headers: headers, params: params }

    context 'when params are valid' do
      let_it_be(:params) { { admin_settings: build(:admin_setting_params) } }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json[:meta]).to eq('message' => 'Changes successfully saved!') }
    end

    context 'when params are not valid' do
      let_it_be(:params) { { admin_settings: { app_contact_username: ' ' } } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when params are not presented' do
      let_it_be(:params) { { admin_settings: {} } }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
