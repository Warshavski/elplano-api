# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::System::HealthController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/system/health/liveness' }

  let_it_be(:meta) do
    {
      db_check:     { status: "ok", message: nil, labels: nil },
      redis_check:  { status: "ok", message: nil, labels: nil },
      cache_check:  { status: "ok", message: nil, labels: nil },
      queues_check: { status: "ok", message: nil, labels: nil }
    }
  end

  before do
    allow(System::Health).to receive(:call).with('liveness').and_return(meta)
  end

  before(:each) { subject }

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    it 'is expected to respond with meta' do
      expect(response).to have_http_status(:ok)

      expect(body_as_json[:meta]).to eq(meta.deep_stringify_keys)
    end
  end
end
