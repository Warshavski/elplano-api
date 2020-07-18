# frozen_string_literal: true

require 'acceptance_helper'

resource "Group's lecturers" do
  explanation <<~DESC
    El Plano group's lecturers API(created for the group by group owner).

    #{Descriptions::Model.lecturer}
  
    <b>NOTES</b> :

      - Also, includes reference to the courses.
  DESC

  let(:student) { create(:student, :group_supervisor) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:course) { create(:course, group: student.group) }
  let(:group) { student.group }
  let(:lecturer) { create(:lecturer, :with_courses, group: group) }
  let(:id) { lecturer.id }

  let(:file) { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:metadata) { AvatarUploader.new(:cache).upload(file) }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group/lecturers' do
    let!(:lecturers) { create_list(:lecturer, 1, :with_courses, group: group) }

    example 'INDEX : Retrieve lecturers created by authenticated user' do
      explanation <<~DESC
        Returns a list of the available lecturers.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = Groups::ShortLecturerSerializer.new(group.lecturers).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/group/lecturers/:id' do
    example 'SHOW : Retrieve information about requested lecturer' do
      explanation <<~DESC
        Returns a single instance of the lecturer.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = LecturerSerializer.new(lecturer, include: [:courses]).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/group/lecturers' do
    with_options scope: %i[lecturer] do
      parameter :first_name, 'Lecturer first name', required: true
      parameter :last_name, 'Lecturer last name', required: true
      parameter :patronymic, 'Lecturer patronymic', required: true
      parameter :email, 'Lecturer contact email'
      parameter :phone, 'Lecturer contact phone number'
      parameter :course_ids, 'Courses of the lecturer'
      parameter :avatar, 'Uploaded file metadata received from `uploads` endpoint'
      parameter :active, 'Lecturer availability flag(currently available lecturer) default: true'
    end

    let(:raw_post) do
      core_params = build(:lecturer_params)

      core_params.merge!(course_ids: [course.id])
      core_params.merge!(avatar: metadata.to_json)

      { lecturer: core_params }.to_json
    end

    example 'CREATE : Create new lecturer' do
      explanation <<~DESC
        Creates and returns created lecturer.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.

        <b>NOTES</b> : 

          - This action allowed only for group owner user.
      DESC

      do_request

      expected_body = LecturerSerializer.new(group.lecturers.last, include: [:courses]).to_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/group/lecturers/:id' do
    with_options scope: %i[lecturer] do
      parameter :first_name, 'Lecturer first name', required: true
      parameter :last_name, 'Lecturer last name', required: true
      parameter :patronymic, 'Lecturer patronymic', required: true
      parameter :email, 'Lecturer contact email'
      parameter :phone, 'Lecturer contact phone number'
      parameter :course_ids, 'Courses of the lecturer'
      parameter :avatar, 'Uploaded file metadata received from `uploads` endpoint'
      parameter :active, 'Lecturer availability flag(currently available lecturer) default: true'
    end

    let(:raw_post) do
      core_params = build(:lecturer_params)

      core_params.merge!(course_ids: [course.id])
      core_params.merge!(avatar: metadata.to_json)

      { lecturer: core_params }.to_json
    end

    example 'UPDATE : Update selected lecturer information' do
      explanation <<~DESC
        Updates and returns updated lecturer.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.

        <b>NOTES</b> : 

          - This action allowed only for group owner user.
      DESC

      do_request

      expected_body = LecturerSerializer.new(lecturer.reload, include: [:courses]).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/group/lecturers/:id' do
    example 'DELETE : Delete selected lecturer' do
      explanation <<~DESC
        Delete lecturer.

        <b>NOTES</b> : 

          - This action allowed only for group owner user.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
