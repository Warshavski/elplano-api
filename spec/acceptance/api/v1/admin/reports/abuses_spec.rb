# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin reports abuses' do
  explanation <<~DESC
    El Plano administration: Abuse reports.
    
    #{Descriptions::Model.abuse_report}
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let_it_be(:abuse_report)  { create(:abuse_report) }
  let_it_be(:id)            { abuse_report.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/reports/abuses' do
    example 'INDEX : Retrieve a list of abuse reports' do
      explanation <<~DESC
        Returns a list of the abuse reports.

        <b>OPTIONAL FILTERS</b> :

        - `"user_id": 1` - Returns abuse reports filtered by reported user.
        - `"reporter_id": 2` - Returns abuse reports filtered by reporter(user).

        Example: 

        <pre>
        {
          "filters": {
            "user_id": 15
            "reporter_id": 2
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See user attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTES<b> :

          - By default, this endpoint returns abuse reports sorted by recently created.
          - By default, this endpoint returns abuse reports limited by 15.
      DESC

      do_request

      expected_body = AbuseReportSerializer.new([abuse_report]).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/reports/abuses/:id' do
    example 'SHOW : Retrieve single abuse report' do
      explanation <<~DESC
        Returns a single instance of the abuse report.

        <b>MORE INFORMATION</b> :

          - See user attributes description in the section description.

        <b>NOTES</b> :

          - Also, includes information about reporter and reported user.
      DESC

      do_request

      expected_body = AbuseReportSerializer
                        .new(abuse_report, include: %i[reporter user])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/admin/reports/abuses/:id' do
    example 'DELETE : Delete selected abuse report' do
      explanation <<~DESC
        Permanently deletes abuse report.
        
        <b>WARNING!</b>: This action cannot be undone.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
