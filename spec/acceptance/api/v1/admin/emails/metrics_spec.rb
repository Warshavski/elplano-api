# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin emails - metrics' do
  explanation <<~DESC
    El Plano administration: Emails metrics.
    
    <b>NOTE</b> : Metrics returned for the last month and grouped by days in this month 

    Meta entity attributes :

     - `date` - Represents date of the day in month.
     - `metrics`
      - `blocks` - The number of emails that were not allowed to be delivered by ISPs.
      - `bounce_drops` - The number of emails that were dropped because of a bounce.
      - `bounces` - The number of emails that bounced instead of being delivered.
      - `clicks` - The number of links that were clicked in your emails.
      - `deferred` - The number of emails that temporarily could not be delivered.
      - `delivered` - The number of emails SendGrid was able to confirm were actually delivered to a recipient.
      - `invalid_emails` - The number of recipients who had malformed email addresses or whose mail provider reported the address as invalid.
      - `opens` - The total number of times your emails were opened by recipients.
      - `processed` - Requests from your website, application, or mail client via SMTP Relay or the API that SendGrid processed.
      - `requests` - The number of emails that were requested to be delivered.
      - `spam_report_drops` - The number of emails that were dropped due to a recipient previously marking your emails as spam.
      - `spam_reports` - The number of recipients who marked your email as spam.
      - `unique_clicks` - The number of unique recipients who clicked links in your emails.
      - `unique_opens` - The number of unique recipients who opened your emails.
      - `unsubscribe_drops` - The number of emails dropped due to a recipient unsubscribing from your emails.
      - `unsubscribes` - The number of recipients who unsubscribed from your emails.
     
    Example:

    <pre>
    {
      "meta": [
        {
          "date": "2019-10-01",
          "metrics": {
            "blocks": 0,
            "bounce_drops": 0,
            "bounces": 0,
            "clicks": 0,
            "deferred": 46,
            "delivered": 0,
            "invalid_emails": 0,
            "opens": 0,
            "processed": 1,
            "requests": 1,
            "spam_report_drops": 0,
            "spam_reports": 0,
            "unique_clicks": 0,
            "unique_opens": 0,
            "unsubscribe_drops": 0,
            "unsubscribes": 0
          }
        }
      ]
    }
    </pre>
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let_it_be(:expected_metrics) do
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
    allow(::Admin::Sendgrid::Metrics).to receive(:cached_call).and_return(expected_metrics)
  end

  get 'api/v1/admin/emails/metrics' do
    example 'SHOW : Retrieves emails metrics' do
      explanation <<~DESC
        This endpoint allows you to retrieve all of your global email statistics in the range of the last month.

        <b>MORE INFORMATION</b> :

          - See response description in the section description.

        <b>NOTES</b> : 

          - Results are CACHED for 5 minutes.
      DESC

      do_request

      expected_meta = { meta: expected_metrics }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end




