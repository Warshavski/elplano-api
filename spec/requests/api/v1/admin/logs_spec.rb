# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::LogsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/logs' }

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

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(body_as_json.keys).to eq(['meta']) }

    it 'contains logs metadata in responce' do
      actual_keys = body_as_json['meta'].first.keys

      expect(actual_keys).to match_array(%w[file_name logs])
    end
  end
end
