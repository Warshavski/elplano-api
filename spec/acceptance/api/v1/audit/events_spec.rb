# frozen_string_literal: true

require 'acceptance_helper'

resource "Users's audit events" do
  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let!(:audit_event) { create(:audit_event, author: user, entity: user) }

  explanation <<~DESC
    El Plano audit events API
    
    Audit event attributes :

      - `audit_type` - Represents type of the audit event(scope of the event).
      - `details` - Represents additional details information(json).
      - `timestamps`

  DESC

  get 'api/v1/audit/events' do
    example "INDEX : Retrieve authenticated users's audit events" do
      explanation <<~DESC
        Returns a list of the user's audit events.

        <b>OPTIONAL FILTERS</b> :

        - `"type": "authentication"` - Returns events filtered by one of the type(#{AuditEvent.audit_types.keys}).

        Example: 

        <pre>
        {
          "filters": {
            "type": "authentication"
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
          - By default, this endpoint returns users without type assumptions.
          - By default, this endpoint returns users limited by 15.
      DESC

      do_request

      expected_data = AuditEventSerializer.new([audit_event]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_data)
    end
  end
end
