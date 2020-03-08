# frozen_string_literal: true

require 'acceptance_helper'

resource "Users's activity events" do
  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:student)     { create(:student, user: user) }
  let(:assignment)  { create(:assignment, student: student) }

  let!(:activity_event) { create(:activity_event, author: user, target: assignment) }

  explanation <<~DESC
    El Plano activity events API
    
    #{Descriptions::Model.activity_event}

    #{Descriptions::Model.invite}

    #{Descriptions::Model.assignment}

    Also, includes information about activity target
  DESC

  get 'api/v1/activity/events' do
    example "INDEX : Retrieve authenticated users's activity events" do
      explanation <<~DESC
        Returns a list of the user's activity events.

        <b>OPTIONAL FILTERS</b> :

        - `"action": "created"` - Returns events filtered by one of the type(#{ActivityEvent.actions.keys}).

        Example: 

        <pre>
        {
          "filters": {
            "action": "created"
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
          - By default, this endpoint returns users without action assumptions.
          - By default, this endpoint returns users limited by 15.
      DESC

      do_request

      expected_data = ActivityEventSerializer
                        .new([activity_event], include: [:target])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_data)
    end
  end
end
