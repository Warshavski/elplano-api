# frozen_string_literal: true

require 'acceptance_helper'

resource 'Students' do
  explanation "El Plano student's profile API"

  let(:student) { create(:student, :group_member) }
  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  get 'api/v1/me/student' do
    context 'Authorized - 200' do
      header 'Authorization', :authorization

      example "SHOW : Retrieve Authenticated Users's  information" do
        explanation <<~DESC
          - `full_name` - represents concatenated student's first, last and middle names
          - `email` - represents email which use to contact with the student
          - `phone` - represents phone which use to contact with the student
          - `about` - represents some detailed information about student(BIO)
          - `social_networks` - represents a list of social networks
          - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member)
          - timestamps

          Also, includes information about the group

          - `title` - represents group name
          - `number` - represents group identity
          - timestamps
        DESC

        do_request

        expected_body = StudentSerializer
                        .new(student, include: [:group])
                        .serialized_json
                        .to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
      example 'SHOW : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end
  end

  put 'api/v1/me/student' do
    context 'Authorized - 200' do
      header 'Authorization', :authorization

      with_options scope: %i[data attributes] do
        parameter :full_name, 'Full name'
        parameter :email, 'Contact email'
        parameter :phone, 'Contact phone'
        parameter :about, 'Detailed information(BIO)'
        parameter :social_networks, 'List of the social networks(twitter, facebook, e.t.c.'
      end

      let(:raw_post) { { data: build(:student_params) }.to_json }

      example "UPDATE : Updates authenticated user's information" do
        explanation <<~DESC
          Update and return student specific information
        DESC

        do_request

        expected_body = StudentSerializer
                        .new(student.reload)
                        .serialized_json
                        .to_s

        expect(status).to eq(200)
        expect(response_body).to eq(expected_body)
      end
    end

    context 'Unauthorized - 401' do
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

      let(:raw_post) do
        {
          data: {
            type: 'student',
            attributes: {
              phone: '1123456789012345678901234567890123456789012345678901234567890'
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
  end
end
