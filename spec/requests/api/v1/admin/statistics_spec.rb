# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::StatisticsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/statistics' }

  let_it_be(:stats) do
    {
      user: {
        total_count: 2,
        week_count: 2,
        month_count: 2
      },
      group: {
        total_count: 2,
        week_count: 1,
        month_count: 2
      }
    }
  end

  before do
    allow(Admin::Statistics::Compose).to receive(:cached_call).and_return(stats)
  end

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(body_as_json.keys).to eq(['meta']) }

    it 'contains statistics metadata in responce' do
      actual_meta_keys = body_as_json['meta'].keys
      actual_counter_keys = body_as_json.dig('meta', 'user').keys

      expect(actual_meta_keys).to match_array(%w[user group])
      expect(actual_counter_keys).to match_array(%w[total_count week_count month_count])
    end
  end
end
