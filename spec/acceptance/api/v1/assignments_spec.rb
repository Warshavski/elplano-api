# frozen_string_literal: true

require 'acceptance_helper'

resource "User's course assignments" do
  explanation <<~DESC
    El Plano course assignments API(creates for group course by group owner).

    Assignment attributes :

      - `title` - Represents assignment name(human readable identity).
      - `description` - Represents assignment description
      - `outdated` - `true` if assignment is available in current time(not expired assignment), otherwise `false` 
      - `expired_at` - Represents expiration time(assignment completion deadline)
      - `timestamps`
  
     Also, includes reference to the course.
  DESC

  let(:student) { create(:student, :group_supervisor) }
  let(:course)  { create(:course, group: student.group) }

  let(:assignment)  { create(:assignment, course: course, author: student)}
  let(:id)          { assignment.id }

  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/assignments' do
    let!(:assignments) { create_list(:assignment, 1, course: course, author: student) }

    example 'INDEX : Retrieve assignments list' do
      explanation <<~DESC
        Returns a list of the available assignments.

        <b>Optional filter params</b> :

          - `"course_id": 1` - Returns assignments for the selected course.
          - `"outdated": true/false` - Returns outdated or active assignments.

        Example: 

        <pre>
        {
          "filters": {
            "course_id": 1,
            "outdated": true
          }
        }
        </pre>

        For more details see "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns assignments sorted by recently created.
          - By default, this endpoint returns assignments without expiration date assumptions.
          - By default, this endpoint returns assignments limited by 15

        See model attribute description in section description.
      DESC

      do_request

      expected_body = AssignmentSerializer.new(assignments).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/assignments/:id' do
    example 'SHOW : Retrieve detailed information about requested assignment' do
      explanation <<~DESC
        Returns a single instance of the assignment.

        Also, includes information about related course.

        See model attribute description in section description.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(assignment, include: [:course])
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/assignments' do
    with_options scope: %i[assignment] do
      parameter :title, 'Assignment title(human readable identity)', required: true
      parameter :description, 'Assignment detailed description or assigment itself'
      parameter :expired_at, 'Assignment expiration timestamp'
      parameter :course_id, '', required: true
    end

    let(:raw_post) do
      { assignment: build(:assignment_params).merge(course_id: course.id) }.to_json
    end

    example 'CREATE : Create a new course assignment' do
      explanation <<~DESC
        Creates and returns created course assignment.

        See model attribute description in section description.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(course.assignments.last, include: [:course])
                        .serialized_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/assignments/:id' do
    with_options scope: %i[assignment] do
      parameter :title, 'Assignment title(human readable identity)', required: true
      parameter :description, 'Assignment detailed description or assigment itself'
      parameter :expired_at, 'Assignment expiration timestamp'
      parameter :course_id, '', required: true
    end

    let(:raw_post) do
      { assignment: build(:assignment_params).merge(course_id: course.id) }.to_json
    end

    example 'UPDATE : Update selected assignment information' do
      explanation <<~DESC
        Updates and return updated assignment.

        See model attribute description in section description.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(assignment.reload, include: [:course])
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/assignments/:id' do
    example 'DELETE : Delete selected course assignment' do
      explanation <<~DESC
        Deletes course assignment.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
