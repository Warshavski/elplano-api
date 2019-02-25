# frozen_string_literal: true

require 'acceptance_helper'

resource 'Events' do
  explanation <<~DESC
    El Plano events API.

    Event attributes :

     - `title` - Represents event name.
     - `description` - Represents event detailed description.
     - `status` - Represents event current status.
       - `confirmed` - The event is confirmed. This is the default status.
       - `tentative` - The event is tentatively confirmed.
       - `cancelled` - The event is cancelled (deleted).
  
     - `recurrence` - Represents recurrence rules.
     - `timezone` - Timezone settings.
     - `start_at` - Represents when event starts.
     - `end_at` - Represents when event ends.
     - timestamps
  
     Also, includes reference to the event creator and attached course.
  DESC

  let(:student) { create(:student, :group_member) }
  let(:course) { create(:course, group: student.group) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:event) { create(:event, title: 'some_new_event', creator: student) }
  let(:id) { event.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/events' do
    let!(:events) { create_list(:event, 1, creator: student) }

    example 'INDEX : Retrieve events created by authenticated user' do
      explanation <<~DESC
        Return list of available events.
      DESC

      do_request

      expected_body = EventSerializer.new(events).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/events/:id' do
    example 'SHOW : Retrieve information about requested event' do
      explanation <<~DESC
        Return single instance of the event.
      DESC

      do_request

      expected_body = EventSerializer.new(event).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/events' do
    with_options scope: %i[dta attributes] do
      parameter :title, 'Event title(human readable identity)', requred: true
      parameter :description, 'Detailed event description'
      # parameter :status, 'Event status', requred: true
      parameter :recurrence, 'Recurrence rules if an event is recurrent'
      parameter :start_at, 'Event start date', requred: true
      parameter :end_at, 'Event end date', requred: true
      parameter :timezone, 'Event timezone', requred: true
      parameter :course, 'The course to which the event is attached. Included in "relationships" category'
    end

    let(:raw_post) do
      course_params = {
        relationships: {
          course: {
            data: { id: course.id, type: 'course' }
          }
        }
      }

      { data: build(:event_params).merge(course_params) }.to_json
    end

    example 'CREATE : Creates new event' do
      explanation <<~DESC
        Create and return created event.
      DESC

      do_request

      expected_body = EventSerializer
                        .new(student.created_events.reload.last)
                        .serialized_json
                        .to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/events/:id' do
    with_options scope: %i[data attributes] do
      parameter :title, 'Event title(human readable identity)', requred: true
      parameter :description, 'Detailed event description'
      # parameter :status, 'Event status'
      parameter :recurrence, 'Recurrence rules if an event is recurrent'
      parameter :start_at, 'Event start date', requred: true
      parameter :end_at, 'Event end date', requred: true
      parameter :timezone, 'Event timezone', requred: true
      parameter :course, 'The course to which the event is attached. Included in "relationships" category'
    end

    let(:raw_post) do
      course_params = {
        relationships: {
          course: {
            data: { id: course.id, type: 'course' }
          }
        }
      }

      { data: build(:event_params).merge(course_params) }.to_json
    end

    example 'UPDATE : Updates selected event information' do
      explanation <<~DESC
        Update and return updated event.
      DESC

      do_request

      expected_body = EventSerializer.new(event.reload).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/events/:id' do
    example 'DELETE : Deletes selected event' do
      explanation <<~DESC
        Delete event.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
