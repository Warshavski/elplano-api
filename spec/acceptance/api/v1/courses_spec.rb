# frozen_string_literal: true

require 'acceptance_helper'

resource 'Courses' do
  explanation <<~DESC
    El Plano courses API.

    Course attributes :

     - `title` - Represents course name(human readable identity).
     - `timestamps`
  
     Also, includes reference to the course lecturer.
  DESC

  let(:student) { create(:student, :group_supervisor) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:lecturer) { create(:lecturer, group: student.group) }
  let(:group)  { student.group }
  let(:course) { create(:course, :with_lecturers, group: group) }
  let(:id) { course.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/courses' do
    let!(:courses) { create_list(:course, 1, :with_lecturers, group: group) }

    example 'INDEX : Retrieve courses created by authenticated user' do
      explanation <<~DESC
        Return list of available courses.
      DESC

      do_request

      expected_body = CourseSerializer.new(group.courses).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/courses/:id' do
    example 'SHOW : Retrieve information about requested course' do
      explanation <<~DESC
        Return single instance of the course.
      DESC

      do_request

      expected_body = CourseSerializer.new(course).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/courses' do
    with_options scope: %i[data attributes] do
      parameter :title, 'Course title(human readable identity)', required: true
      parameter :lecturers, 'Lecturers of the course. Included in "relationships" category'
    end

    let(:raw_post) do
      lecturer_params = {
        relationships: {
          lecturers: {
            data: [{ id: lecturer.id, type: 'lecturer' }]
          }
        }
      }

      { data: build(:course_params).merge(lecturer_params) }.to_json
    end

    example 'CREATE : Create new course' do
      explanation <<~DESC
        Create and return created course.
      DESC

      do_request

      expected_body = CourseSerializer.new(group.courses.last).serialized_json.to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/courses/:id' do
    with_options scope: %i[data attributes] do
      parameter :title, 'Course title(human readable identity)', required: true
      parameter :lecturers, 'Lecturers of the course. Included in "relationships" category'
    end

    let(:raw_post) do
      lecturer_params = {
        relationships: {
          lecturers: {
            data: [{ id: lecturer.id, type: 'lecturer' }]
          }
        }
      }

      { data: build(:course_params).merge(lecturer_params) }.to_json
    end

    example 'UPDATE : Update selected course information' do
      explanation <<~DESC
        Update and return updated course.
      DESC

      do_request

      expected_body = CourseSerializer.new(course.reload).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/courses/:id' do
    example 'DELETE : Delete selected course' do
      explanation <<~DESC
        Delete course.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
