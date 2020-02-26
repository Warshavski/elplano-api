# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin logs' do
  explanation <<~DESC
    El Plano administration: Logs management.
    
    #{Descriptions::Model.application_logs}
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let_it_be(:log) do
    {
      file_name: 'application.log',
      logs: [
        "# Logfile created on 2019-10-07 17:08:07 +0300 by logger.rb/61378",
        "I, [2019-10-07T17:16:44.449328 #1022]  INFO -- : hello world",
        "E, [2019-10-07T17:16:44.449940 #1022] ERROR -- : hello again"
      ]
    }
  end

  before do
    allow(Admin::Logs::Fetch).to receive(:call).and_return([log])
  end

  get 'api/v1/admin/logs' do
    example 'SHOW : Get application logs' do
      explanation <<~DESC
        Get last 2000 application logs.
      DESC

      do_request

      expected_meta = { meta: [log] }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
