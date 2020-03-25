# frozen_string_literal: true

require 'acceptance_helper'

resource "Admin activity events" do
  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:student)     { create(:student, user: user) }
  let(:assignment)  { create(:assignment, student: student) }

  let!(:activity_event) { create(:activity_event, author: user, target: assignment) }

  explanation <<~DESC
    El Plano administration: activity events API
    
    #{Descriptions::Model.activity_event}

    #{Descriptions::Model.invite}

    #{Descriptions::Model.assignment}

    #{Descriptions::Model.user}

    Also, includes information about activity target and author
  DESC

  get 'api/v1/admin/activity/events' do
    example "INDEX : Retrieve users activity events" do
      explanation <<~DESC
        Returns a list of the user's activity events.

        <b>OPTIONAL FILTERS</b> :

        - `"action": "created"` - Returns events filtered by one of the type(#{ActivityEvent.actions.keys}).
        - `"author_id": 1` - Returns events filtered by its author

        Example: 

        <pre>
        {
          "filters": {
            "action": "created",
            "author_id": 1
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
                        .new([activity_event], include: %i[target author])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_data)
    end
  end
end
