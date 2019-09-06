# frozen_string_literal: true

require 'acceptance_helper'

resource "User's events" do
  explanation <<~DESC
    El Plano user's events API(event created by user).
    
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
     - `background_color` - Represents the background color.
     - `foreground_color` - Represents the foreground color that can be used to write on top of a background with 'background' color.
     - `timestamps`
  
     Also, includes references to the event creator, attached course, and for whom the event was created.
  DESC

  let(:student) { create(:student, :group_member) }
  let(:course)  { create(:course, group: student.group) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let!(:event) { create(:event, creator: student, eventable: student) }
  let(:id) { event.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/events' do
    example 'INDEX : Retrieve events created by authenticated user' do
      explanation <<~DESC
        Returns a list of the available events.

        <b>NOTE<b>:

        - by default, this endpoint returns all appointed events(personal + group)
        - be default, this endpoint returns sorts events by recently created

        <b>Optional query params:</b>

          - `?scope=authored` - Filter by event scope:
            - `authored` - created by current authenticated student
            - `appointed` - created for current authenticated student

          - `?type=personal` - Filter by event type(eventable type):
            - `group` - created for everyone in current student's group
            - `personal` - create only for current user(self event and personal events from group owner)

        See model attributes description in the section description.
      DESC

      do_request

      expected_body = EventSerializer.new([event]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/events/:id' do
    example 'SHOW : Retrieve information about requested event' do
      explanation <<~DESC
        Returns a single instance of the event.

        See model attributes description in the section description.
      DESC

      do_request

      expected_body = EventSerializer.new(event).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/events' do
    with_options scope: %i[event] do
      parameter :title, 'Event title(human readable identity)', required: true
      parameter :description, 'Detailed event description'
      # parameter :status, 'Event status', required: true
      parameter :recurrence, 'Recurrence rules if an event is recurrent'
      parameter :start_at, 'Event start date', required: true
      parameter :end_at, 'Event end date', required: true
      parameter :timezone, 'Event timezone', required: true
      parameter :course_id, 'The course identity to which the event is attached'
      parameter :eventable_type, 'The entity type to which the event is attached(student, group)', required: true
      parameter :eventable_id, 'The entity identity to which the event is attached', required: true
      parameter :background_color, 'The background color (HEX)'
      parameter :foreground_color, "The foreground color that can be used to write on top of a background with 'background' color (HEX)"
    end

    let(:raw_post) do
      {
        event: build(:event_params).merge(course_id: course.id, eventable_id: student.id)
      }.to_json
    end

    example 'CREATE : Creates new event' do
      explanation <<~DESC
        Creates and returns created event.

        <b>NOTE</b> :
 
          - An authenticated user can create an event for a group or any group member <b>ONLY</b> in the case when the authenticated user is a group owner(group president).
          - Any authenticated user can create events for himself.
          - `start_at` should be after or on current date and time and before `end_at` and `end_at` should be after `start_at`

        See model attributes description in the section description.
      DESC

      do_request

      expected_body = EventSerializer
                        .new(student.created_events.last)
                        .serialized_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/events/:id' do
    with_options scope: %i[event] do
      parameter :title, 'Event title(human readable identity)', required: true
      parameter :description, 'Detailed event description'
      # parameter :status, 'Event status'
      parameter :recurrence, 'Recurrence rules if an event is recurrent'
      parameter :start_at, 'Event start date', required: true
      parameter :end_at, 'Event end date', required: true
      parameter :timezone, 'Event timezone', required: true
      parameter :course_id, 'The course identity to which the event is attached'
      parameter :eventable_type, 'The entity type to which the event is attached(student, group)', required: true
      parameter :eventable_id, 'The entity identity to which the event is attached', required: true
      parameter :background_color, 'The background color (HEX)'
      parameter :foreground_color, "The foreground color that can be used to write on top of a background with 'background' color (HEX)"
    end

    let(:raw_post) do
      {
        event: build(:event_params).merge(course_id: course.id, eventable_id: student.id)
      }.to_json
    end

    example 'UPDATE : Updates selected event information' do
      explanation <<~DESC
        Updates and returns updated event.

        <b>NOTE</b> : 

          - update allowed only for events created by current authenticated student.
          - `start_at` should be after or on current date and time and before `end_at` and `end_at` should be after `start_at`.

        See model attributes description in the section description.
      DESC

      do_request

      expected_body = EventSerializer.new(event.reload).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/events/:id' do
    example 'DELETE : Deletes selected event' do
      explanation <<~DESC
        Deletes an event.

        <b>NOTE</b> :

          - delete allowed only for events created by current authenticated student.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
