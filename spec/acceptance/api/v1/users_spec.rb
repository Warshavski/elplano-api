# frozen_string_literal: true

require 'acceptance_helper'

resource "User's profile" do
  let(:user)  { create(:user, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  explanation <<~DESC
    El Plano user's profile API
    
    Users attributes :

      - `email` - Represents email that was used to register a user in the application(unique in application scope).
      - `username` - Represents used's user name.
      - `admin` - `false` if regular user `true`, if the user has access to application settings.
      - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
      - `avatar_url` - Represents user's avatar.
      - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
      - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
      - `locale` - Represents user's locale
      - `timestamps`
     
    Student attributes :
  
      - `full_name` - Represents concatenated student's first, last and middle names.
      - `email` - Represents email which is used to contact with the student.
      - `phone` - Represents phone which is used to contact with the student.
      - `about` - Represents some detailed information about student(BIO).
      - `social_networks` - Represents a list of social networks.
      - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
      - `timestamps`
    
    Also, includes relationship to the student's group
  DESC

  get 'api/v1/user' do
    example "SHOW : Retrieve authenticated users's profile" do
      explanation <<~DESC
        Returns detailed information about user.

        See attributes description in the section description.
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq(UserSerializer.new(user, include: [:student]).serialized_json)
    end
  end

  put 'api/v1/user' do
    with_options scope: %i[user] do
      parameter :full_name, 'Full name'
      parameter :email, 'Contact email'
      parameter :phone, 'Contact phone'
      parameter :about, 'Detailed information(BIO)'
      parameter :social_networks, 'List of the social networks(twitter, facebook, e.t.c.'
      parameter :student_attributes, 'Student attributes(detailed user profile info)'
    end

    let(:raw_post) { { user: build(:profile_params) }.to_json }

    example "UPDATE : Updates authenticated user's information" do
      explanation <<~DESC
        Updates and returns user specific information.

        See attributes description in the section description.
      DESC

      do_request

      expected_body = UserSerializer.new(user.reload, include: [:student]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
