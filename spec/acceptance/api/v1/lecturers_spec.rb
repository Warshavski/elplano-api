# frozen_string_literal: true

require 'acceptance_helper'

resource 'Lecturers' do
  explanation <<~DESC
    El Plano lecturers API.

    Course attributes :

     - `first_name`
     - `last_name`
     - `patronymic`
     - timestamps
  
     Also, includes reference to the courses.
  DESC

  let(:student) { create(:student, :group_supervisor) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:course) { create(:course, group: student.group) }
  let(:group)  { student.group }
  let(:lecturer) { create(:lecturer, :with_courses, group: group) }
  let(:id) { lecturer.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/lecturers' do
    let!(:lecturers) { create_list(:lecturer, 1, :with_courses, group: group) }

    example 'INDEX : Retrieve lecturers created by authenticated user' do
      explanation <<~DESC
        Return list of available lecturers.
      DESC

      do_request

      expected_body = LecturerSerializer.new(group.lecturers).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/lecturers/:id' do
    example 'SHOW : Retrieve information about requested lecturer' do
      explanation <<~DESC
        Return single instance of the lecturer.
      DESC

      do_request

      expected_body = LecturerSerializer.new(lecturer).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/lecturers' do
    with_options scope: %i[dta attributes] do
      parameter :first_name, 'Lecturer first name', requred: true
      parameter :last_name, 'Lecturer last name', requred: true
      parameter :patronymic, 'Lecturer patronymic', requred: true
      parameter :courses, 'Courses of the lecturer. Included in "relationships" category'
    end

    let(:raw_post) do
      course_params = {
        relationships: {
          courses: {
            data: [{ id: course.id, type: 'courses' }]
          }
        }
      }

      { data: build(:lecturer_params).merge(course_params) }.to_json
    end

    example 'CREATE : Create new lecturer' do
      explanation <<~DESC
        Create and return created lecturer.
      DESC

      do_request

      expected_body = LecturerSerializer.new(group.lecturers.last).serialized_json.to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/lecturers/:id' do
    with_options scope: %i[dta attributes] do
      parameter :first_name, 'Lecturer first name', requred: true
      parameter :last_name, 'Lecturer last name', requred: true
      parameter :patronymic, 'Lecturer patronymic', requred: true
      parameter :courses, 'Courses of the lecturer. Included in "relationships" category'
    end

    let(:raw_post) do
      course_params = {
        relationships: {
          courses: {
            data: [{ id: course.id, type: 'courses' }]
          }
        }
      }

      { data: build(:lecturer_params).merge(course_params) }.to_json
    end

    example 'UPDATE : Update selected lecturer information' do
      explanation <<~DESC
        Update and return updated lecturer.
      DESC

      do_request

      expected_body = LecturerSerializer.new(lecturer.reload).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/lecturers/:id' do
    example 'DELETE : Delete selected lecturer' do
      explanation <<~DESC
        Delete lecturer.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
