# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin statistics' do
  explanation <<~DESC
    El Plano administration: Application statistics.
    
    Meta entity attributes :

     - `total_count` - Represents the number of records created for all time.
     - `week_count` - Represents the number of records created for the last week.
     - `month_count` - Represents the number of records created for the last month.
     
    Example:

    <pre>
    {
      "meta": {
        "user": {
          "total_count": 10,
          "week_count": 1,
          "month_count": 5
        },
        "group": {
          "total_count": 5,
          "week_count": 1,
          "month_count": 2
        }
      }
    }
    </pre>
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let_it_be(:expected_stats) do
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
    allow(::Admin::Statistics::Compose).to receive(:cached_call).and_return(expected_stats)
  end

  get 'api/v1/admin/statistics' do
    example 'SHOW : Retrieves application statistics' do
      explanation <<~DESC
        Returns a metadata with different counters.

        <b>NOTES</b> : 

          - Because of the heavy calculations, results are CACHED for 15 minutes.
      DESC

      do_request

      expected_meta = { meta: expected_stats }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
