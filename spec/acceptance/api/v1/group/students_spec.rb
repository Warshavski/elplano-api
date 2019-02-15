# frozen_string_literal: true

require 'acceptance_helper'

resource 'Group members' do
  explanation "El Plano group members API"

  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:student) { create(:student, :group_member) }
  let(:id) { student.id }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group/students' do
    context 'Authorized - 200' do
      example 'INDEX : Retrieve group members' do
        explanation <<~DESC
          Student attributes :

          - `full_name` - represents concatenated student's first, last and middle names
          - `email` - represents email which is used to contact with the student
          - `phone` - represents phone which is used to contact with the student
          - `about` - represents some detailed information about student(BIO)
          - `social_networks` - represents a list of social networks
          - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member)
          - timestamps

          Also, includes information about a user and relationships to the group and user

          - `email` - represents email that was used to register a user in the application(unique in application scope)
          - `username` - used as user name
          - `admin` - `false` if regular user `true`, if the user has access to application settings
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`
          - `avatar_url` - user's avatar URL
          - timestamps
        DESC

        do_request

        expected_body = StudentSerializer
                          .new(student.group.students, include: [:user])
                          .serialized_json
                          .to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'INDEX : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/group/students/:id' do
    context 'Authorized - 200' do
      example "SHOW : Show information about particular group member" do
        explanation <<~DESC
          Student attributes :

          - `full_name` - represents concatenated student's first, last and middle names
          - `email` - represents email which is used to contact with the student
          - `phone` - represents phone which is used to contact with the student
          - `about` - represents some detailed information about student(BIO)
          - `social_networks` - represents a list of social networks
          - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member)
          - timestamps

          Also, includes information about a user and relationships to the group and user

          - `email` - represents email that was used to register a user in the application(unique in application scope)
          - `username` - used as user name
          - `admin` - `false` if regular user `true`, if the user has access to application settings
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`
          - `avatar_url` - user's avatar URL
          - timestamps
        DESC

        do_request

        expected_body = StudentSerializer
                          .new(student, include: [:user])
                          .serialized_json
                          .to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'SHOW : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Not found - 404' do
      let(:id) { 0 }

      example 'SHOW : Returns 404 status code' do
        explanation <<~DESC
          Returns 404 status code in case if requested student not exists
        DESC

        do_request

        expect(status).to eq(404)
      end
    end
  end
end
