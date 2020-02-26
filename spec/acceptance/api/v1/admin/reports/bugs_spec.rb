# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin reports bugs' do
  explanation <<~DESC
    El Plano administration: Bug reports.
    
    #{Descriptions::Model.bug_report}
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let_it_be(:bug_report)  { create(:bug_report) }
  let_it_be(:id)          { bug_report.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/reports/bugs' do
    example 'INDEX : Retrieve a list of bug reports' do
      explanation <<~DESC
        Returns a list of the bug reports.

        <b>OPTIONAL FILTERS</b> :

        - `"user_id": 1` - Returns bug reports filtered by reporter(user).

        Example: 

        <pre>
        {
          "filters": {
            "user_id": 15
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See user attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns bug reports sorted by recently created.
          - By default, this endpoint returns bug reports limited by 15.
      DESC

      do_request

      expected_body = BugReportSerializer.new([bug_report]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/reports/bugs/:id' do
    example 'SHOW : Retrieve single bug report' do
      explanation <<~DESC
        Returns a single instance of the bug report.

        See user attributes description in the section description.
      DESC

      do_request

      expected_body = BugReportSerializer.new(bug_report).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/admin/reports/bugs/:id' do
    example 'DELETE : Delete selected bug report' do
      explanation <<~DESC
        Permanently deletes bug report.
        
        <b>WARNING!</b>: This action cannot be undone.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
