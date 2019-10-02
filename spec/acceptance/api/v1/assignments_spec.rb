# frozen_string_literal: true

require 'acceptance_helper'

resource "User's course assignments" do
  explanation <<~DESC
    El Plano course assignments API(creates for group course by group owner).

    Assignment attributes :

      - `title` - Represents assignment name(human readable identity).
      - `description` - Represents assignment description.
      - `outdated` - `true` if assignment is available in current time(not expired assignment), otherwise `false`. 
      - `accomplished` - `true` if assignment is accomplished(completed), otherwise `false`.
      - `expired_at` - Represents expiration time(assignment completion deadline).
      - `timestamps`
  
    Attachment attributes :

      - `filename` - Represents original file name.
      - `size` - Represents file size(bytes).
      - `mime_type` - Represents file type(https://www.freeformatter.com/mime-types-list.html).
      - `url` - Represents url to download file.
      - `timestamps`

    Course attributes :

      - `title` - Represents course name(human readable identity).
      - `active` - `true` if course is available in current time(not archived course), otherwise `false`
      - `timestamps`

     Also, includes reference to the course.
  DESC

  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:course)  { create(:course, group: student.group) }

  let_it_be(:assignment) { create(:assignment, course: course, author: student)}

  let_it_be(:id) { assignment.id }

  let_it_be(:user)  { student.user }
  let_it_be(:token) { create(:token, resource_owner_id: user.id).token }
  let_it_be(:authorization) { "Bearer #{token}" }

  let_it_be(:file) { fixture_file_upload('spec/fixtures/files/dk.png') }
  let_it_be(:metadata) { AvatarUploader.new(:cache).upload(file) }

  let_it_be(:attachment) do
    create(:attachment, author: user, attachable: assignment, attachment_data: metadata)
  end

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/assignments' do
    example 'INDEX : Retrieve assignments list' do
      explanation <<~DESC
        Returns a list of the available assignments.

        <b>Optional filter params</b> :

          - `"course_id": 1` - Returns assignments for the selected course.
          - `"outdated": true/false` - Returns outdated or active assignments.
          - `"accomplished": true/false` - Returns completed or not assignments.

        Example: 

        <pre>
        {
          "filters": {
            "course_id": 1,
            "outdated": true,
            "accomplished": false
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

      expected_body = AssignmentSerializer
                        .new([assignment], params: { exclude: [:attachments] })
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/assignments/:id' do
    example 'SHOW : Retrieve detailed information about requested assignment' do
      explanation <<~DESC
        Returns a single instance of the assignment.

        Also, includes information about related course and attachments.

        See model attribute description in section description.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(assignment, include: %i[course attachments])
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
      parameter :attachments, 'Uploaded files metadata(collection) received from `uploads` endpoint'
    end

    let(:raw_post) do
      params = build(:assignment_params)
                 .merge(course_id: course.id, attachments: [metadata.to_json])

      { assignment:  params }.to_json
    end

    example 'CREATE : Create a new course assignment' do
      explanation <<~DESC
        Creates and returns created course assignment.

        Also, includes information about related course and attachments.

        See model attribute description in section description.
        
        See `uploads` endpoint description for more info.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(course.assignments.last, include: %i[course attachments])
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

        Also, includes information about related course and attachments.

        See model attribute description in section description.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = AssignmentSerializer
                        .new(assignment.reload, include: %i[course attachments])
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

  post 'api/v1/assignments/:id/accomplishment' do
    with_options scope: :accomplishment do
      parameter :attachments, 'Uploaded files metadata(collection) received from `uploads` endpoint'
    end

    let(:raw_post) do
      { accomplishment: { attachments: [metadata.to_json] } }.to_json
    end

    example 'POST : Accomplish course assignment' do
      explanation <<~DESC
        Mark course assignment as accomplished.
      DESC

      expected_meta = {
        meta: {
          message: 'Changes successfully saved!'
        }
      }

      do_request

      expect(status).to eq(201)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end

  delete 'api/v1/assignments/:id/accomplishment' do
    let!(:accomplishment) do
      create(:accomplishment, student: student, assignment: assignment)
    end

    example 'DELETE : Remove course assignment accomplishment' do
      explanation <<~DESC
        Mark course assignment as not accomplished(remove accomplished mark).
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
