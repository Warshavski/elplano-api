# frozen_string_literal: true

require 'acceptance_helper'

resource "Group's courses" do
  explanation <<~DESC
    El Plano courses API(created for group by group owner).

    Course attributes :

     - `title` - Represents course name(human readable identity).
     - `timestamps`
  
     Also, includes reference to the course lecturer.
  DESC

  let(:student) { create(:student, :group_supervisor) }

  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:lecturer) { create(:lecturer, group: student.group) }
  let(:group)  { student.group }
  let(:course) { create(:course, :with_lecturers, group: group) }
  let(:id) { course.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group/courses' do
    let!(:courses) { create_list(:course, 1, :with_lecturers, group: group) }

    example 'INDEX : Retrieve courses created by authenticated user' do
      explanation <<~DESC
        Returns a list of the available courses.
      DESC

      do_request

      expected_body = CourseSerializer.new(group.courses).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/group/courses/:id' do
    example 'SHOW : Retrieve information about requested course' do
      explanation <<~DESC
        Returns a single instance of the course.
      DESC

      do_request

      expected_body = CourseSerializer.new(course).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/group/courses' do
    with_options scope: %i[course] do
      parameter :title, 'Course title(human readable identity)', required: true
      parameter :lecturer_ids, 'Lecturers of the course.'
    end

    let(:raw_post) do
      { course: build(:course_params).merge(lecturer_ids: [lecturer.id]) }.to_json
    end

    example 'CREATE : Create new course' do
      explanation <<~DESC
        Creates and returns created course.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = CourseSerializer.new(group.courses.last).serialized_json.to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/group/courses/:id' do
    with_options scope: %i[course] do
      parameter :title, 'Course title(human readable identity)', required: true
      parameter :lecturer_ids, 'Lecturers of the course.'
    end

    let(:raw_post) do
      { course: build(:course_params).merge(lecturer_ids: [lecturer.id]) }.to_json
    end

    example 'UPDATE : Update selected course information' do
      explanation <<~DESC
        Updates and return updated course.

        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expected_body = CourseSerializer.new(course.reload).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/group/courses/:id' do
    example 'DELETE : Delete selected course' do
      explanation <<~DESC
        Deletes course.
        
        <b>NOTE</b> : This action allowed only for group owner user.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
