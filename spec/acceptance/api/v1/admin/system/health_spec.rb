# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin system health' do
  explanation <<~DESC
    El Plano administration: System components health status.
    
    Meta payload :

     - `component_name` - Represents name of the system component health check.
                            (`db_check`, `redis_check`, `cache_check` `queues_check`).

      - `status` - Status of the system component check.
      - `message` - Additional message
      - `labels`
  DESC

  let(:user)  { create(:user) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/system/health?type=liveness' do
    parameter :type, 'Health check type identity(`liveness`, `readiness`)', required: true

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

    example 'SHOW : Retrieve system health checks status' do
      explanation <<~DESC
        Returns meta-information about system components health status.

        <b>NOTE</b> : Returns `{}` in case if information can not be received.
      DESC

      do_request

      expected_meta = { meta: meta }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
