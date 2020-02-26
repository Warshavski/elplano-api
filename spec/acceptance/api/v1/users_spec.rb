# frozen_string_literal: true

require 'acceptance_helper'

resource "User's profile" do
  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

  explanation <<~DESC
    El Plano user's profile API
    
    Users attributes :

    #{Descriptions::Model.user}
     
    #{Descriptions::Model.student}
    
    <b>NOTES</b :

      - Also, includes relationship to the student's group
  DESC

  get 'api/v1/user' do
    example "SHOW : Retrieve authenticated users's profile" do
      explanation <<~DESC
        Returns detailed information about user.

        <b>MORE INFORMATION</b>

          - See attributes description in the section description.
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq(UserSerializer.new(user, include: [:student]).serialized_json)
    end
  end

  put 'api/v1/user' do
    with_options scope: :user do
      parameter :avatar, 'Uploaded file metadata received from `uploads` endpoint'
      parameter :locale, 'Preferred application localization'
      parameter :settings, 'Custom user related settings(theme...)'

      with_options scope: %i[user student_attributes] do
        parameter :full_name, 'Full name'
        parameter :email, 'Contact email'
        parameter :phone, 'Contact phone'
        parameter :about, 'Detailed information(BIO)'
        parameter :birthday, 'Date of birthday'
        parameter :gender, "#{Student.genders.keys}"
        parameter :social_networks, 'List of the social networks(twitter, facebook, e.t.c.'
      end
    end

    let(:raw_post) do
      core_params = build(:profile_params)

      core_params.merge!(avatar: metadata.to_json)

      { user: core_params }.to_json
    end

    example "UPDATE : Updates authenticated user's information" do
      explanation <<~DESC
        Updates and returns user specific information.

        <b>MORE INFORMATION</b>

          - See attributes description in the section description.
      DESC

      do_request

      expected_body = UserSerializer.new(user.reload, include: [:student]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/user' do
    with_options scope: %i[user] do
      parameter :password, "Authenticated user's password. Used to confirm action", required: true
    end

    let(:raw_post) { { user: { password: '123456' } }.to_json }

    example "DELETE : Deletes user's profile" do
      explanation <<~DESC
        Deletes a authenticated user's profile with all related data

        <b>NOTE</b> : 

          - This action requires authenticated user's password confirmation.
         
        <b>WARNING</b> 

          - This action CANNOT be undone.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
