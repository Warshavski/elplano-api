# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::Emails::MetricsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/emails/metrics' }

  let_it_be(:metrics) do
    [
      {
        "date"=>"2019-10-01",
        "metrics"=> {
          "blocks"=>0,
          "bounce_drops"=>0,
          "bounces"=>0,
          "clicks"=>0,
          "deferred"=>46,
          "delivered"=>0,
          "invalid_emails"=>0,
          "opens"=>0,
          "processed"=>1,
          "requests"=>1,
          "spam_report_drops"=>0,
          "spam_reports"=>0,
          "unique_clicks"=>0,
          "unique_opens"=>0,
          "unsubscribe_drops"=>0,
          "unsubscribes"=>0
        }
      }
    ]
  end

  before do
    allow(::Admin::Sendgrid::Metrics).to receive(:cached_call).and_return(metrics)
  end

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(body_as_json.keys).to eq(['meta']) }

    it 'contains statistics metadata in responce' do
      actual_meta_keys = body_as_json['meta'].first.keys

      expect(actual_meta_keys).to match_array(%w[date metrics])
    end
  end
end
