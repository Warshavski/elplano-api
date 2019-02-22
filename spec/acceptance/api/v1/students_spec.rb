# frozen_string_literal: true

require 'acceptance_helper'

resource 'Students' do
  explanation <<~DESC
    El Plano student's profile API.

    Student attributes :
  
      - `full_name` - Represents concatenated student's first, last and middle names.
      - `email` - Represents email which is used to contact with the student.
      - `phone` - Represents phone which is used to contact with the student.
      - `about` - Represents some detailed information about student(BIO).
      - `social_networks` - Represents a list of social networks.
      - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
      - timestamps
    
      Also, includes information about a group.
    
      - `title` - Represents group human readable identity.
      - `number` - Represents group main identity.
      - timestamps
  DESC

  let(:student) { create(:student, :group_member) }
  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/student' do
    example "SHOW : Retrieve Authenticated Users's  information" do
      explanation <<~DESC
        Return detailed information about user's profile(student information).
      DESC

      do_request

      expected_body = StudentSerializer.new(student).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/student' do
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
        Update and return student specific information.
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
end
