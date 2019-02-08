# frozen_string_literal: true

require 'acceptance_helper'

resource 'Events' do
  explanation 'El Plano events API'

  let(:student) { create(:student, :group_member) }
  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:event) { create(:event, title: 'some_new_event', creator: student) }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  get 'api/v1/me/events' do
    let!(:events) { create_list(:event, 1, creator: student) }

    context 'Authorized - 200' do
      header 'Authorization', :authorization

      example 'INDEX : Retrieve events created by authenticated user' do
        explanation <<~DESC
          - `title` - represents event name
          - `description` - represents event detailed description
          - `status` - represents event current status
            - `confirmed` - The event is confirmed. This is the default status.
            - `tentative` - The event is tentatively confirmed.
            - `cancelled` - The event is cancelled (deleted).

          - `recurrence` - represents recurrence rules
          - `timezone` - timezone settings
          - `start_at` - represents when event starts
          - `end_at` - represents when event ends
          - timestamps

          Also, includes reference to the event creator
        DESC

        do_request

        expected_body = EventSerializer
                        .new(student.created_events)
                        .serialized_json
                        .to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      example 'INDEX : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/me/events/:id' do
    context 'Authorized - 200' do
      header 'Authorization', :authorization

      let(:id) { event.id }

      example 'SHOW : Retrieve information about requested event' do
        explanation <<~DESC
          Returns single instance of the event. Detailed information see INDEX description
        DESC

        do_request

        expected_body = EventSerializer.new(event).serialized_json.to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Not found - 404' do
      header 'Authorization', :authorization

      let(:id) { 0 }

      example 'SHOW : Returns 404 status code' do
        explanation <<~DESC
          Returns 404 status code in case if requested event not exists
        DESC

        do_request

        expect(status).to eq(404)
      end
    end

    context 'Unauthorized - 401' do
      let(:id) { event.id }

      example 'SHOW : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/me/events' do
    context 'Authorized - 201' do
      header 'Authorization', :authorization

      with_options scope: %i[dta attributes] do
        parameter :title, 'Event title(human readable identity)', requred: true
        parameter :description, 'Detailed event description'
        # parameter :status, 'Event status'
        parameter :recurrence, 'Recurrence rules if an event is recurrent'
        parameter :start_at, 'Event start date', requred: true
        parameter :end_at, 'Event end date', requred: true
        parameter :timezone, 'Event timezone', requred: true
      end

      let(:raw_post) { { data: build(:event_params) }.to_json }

      example 'CREATE : Creates new event' do
        explanation <<~DESC
          Create and return created event
        DESC

        do_request

        expected_body = EventSerializer
                        .new(student.created_events.first)
                        .serialized_json
                        .to_s

        expect(status).to eq(201)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      example 'CREATE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Missing parameters - 400' do
      header 'Authorization', :authorization

      example 'CREATE : Returns 400 status code' do
        explanation <<~DESC
          Returns 400 status code in case of missing parameters
        DESC

        do_request

        expect(status).to eq(400)
      end
    end

    context 'Invalid parameters - 422' do
      header 'Authorization', :authorization

      let(:raw_post) do
        {
          data: {
            type: 'event',
            attributes: {
              title: nil,
              status: nil,
              start_at: nil,
              end_at: nil,
              timezone: 'wat timezone'
            }
          }
        }.to_json
      end

      example 'CREATE : Returns 422 status code' do
        explanation <<~DESC
          Returns 422 status code in case of invalid parameters
        DESC

        do_request

        expect(status).to eq(422)
      end
    end
  end

  put 'api/v1/me/events/:id' do
    context 'Authorized - 200' do
      header 'Authorization', :authorization

      with_options scope: %i[data attributes] do
        parameter :title, 'Event title(human readable identity)', requred: true
        parameter :description, 'Detailed event description'
        # parameter :status, 'Event status'
        parameter :recurrence, 'Recurrence rules if an event is recurrent'
        parameter :start_at, 'Event start date', requred: true
        parameter :end_at, 'Event end date', requred: true
        parameter :timezone, 'Event timezone', requred: true
      end

      let(:raw_post) { { data: build(:event_params) }.to_json }
      let(:id) { event.id }

      example 'UPDATE : Updates selected event information' do
        explanation <<~DESC
          Update and return updated event
        DESC

        do_request

        expected_body = EventSerializer.new(event.reload).serialized_json.to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      let(:id) { event.id }

      example 'UPDATE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Missing parameters - 400' do
      header 'Authorization', :authorization

      let(:id) { event.id }

      example 'UPDATE : Returns 400 status code' do
        explanation <<~DESC
          Returns 400 status code in case of missing parameters
        DESC

        do_request

        expect(status).to eq(400)
      end
    end

    context 'Invalid parameters - 422' do
      header 'Authorization', :authorization

      let(:id) { event.id }

      let(:raw_post) do
        {
          data: {
            type: 'event',
            attributes: {
              title: nil,
              status: nil,
              start_at: nil,
              end_at: nil,
              timezone: 'wat timezone'
            }
          }
        }.to_json
      end

      example 'UPDATE : Returns 422 status code' do
        explanation <<~DESC
          Returns 422 status code in case of invalid parameters
        DESC

        do_request

        expect(status).to eq(422)
      end
    end

    context 'Not found - 404' do
      header 'Authorization', :authorization

      let(:id) { 0 }

      example 'UPDATE : Returns 404 status code' do
        explanation <<~DESC
          Returns 404 status code in case if requested event not exists
        DESC

        do_request

        expect(status).to eq(404)
      end
    end
  end

  delete 'api/v1/me/events/:id' do
    context 'Authorized - 200' do
      header 'Authorization', :authorization

      let(:id) { event.id }

      example 'DELETE : Deletes selected event' do
        explanation <<~DESC
          Deletes event
        DESC

        do_request

        expect(status).to eq(204)
      end
    end

    context 'Unauthorized - 401' do
      let(:id) { event.id }

      example 'DELETE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Not found - 404' do
      header 'Authorization', :authorization

      let(:id) { 0 }

      example 'DELETE : Returns 404 status code' do
        explanation <<~DESC
          Returns 404 status code in case if requested event not exists
        DESC

        do_request

        expect(status).to eq(404)
      end
    end
  end
end
