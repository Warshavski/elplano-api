# frozen_string_literal: true

require 'acceptance_helper'

resource "User's group" do
  explanation <<~DESC
    El Plano user's group API'.

    #{Descriptions::Model.group}
  DESC

  let(:student) { create(:student, :group_supervisor) }

  let(:user) { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:group) { student.group }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group' do
    example "SHOW : Retrieve information about user's group" do
      explanation <<~DESC
        Returns detailed information about user's group.
        
        <b>MORE INFORMATION</b> :
        
          - See group attributes description in the section description.
      DESC

      do_request

      expected_body = GroupSerializer.new(group).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/group' do
    let_it_be(:student) { create(:student) }

    with_options scope: %i[group] do
      parameter :title, 'Human readable identity)', required: true
      parameter :number, 'Main group identity', required: true
    end

    let(:raw_post) { { group: build(:group_params) }.to_json }

    example 'CREATE : Creates new group' do
      explanation <<~DESC
        Creates and returns created group.

        <b>MORE INFORMATION</b> :
        
          - See group attributes description in the section description.

        <b>NOTES</b> : 

          - This action allowed only for non-group owner user's or for a user that has no group membership.
      DESC

      do_request

      expected_body = GroupSerializer
                        .new(student.reload.group)
                        .serialized_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/group' do
    with_options scope: %i[group] do
      parameter :title, 'Human readable identity)', required: true
      parameter :number, 'Main group identity', required: true
    end

    let(:raw_post) { { group: build(:group_params) }.to_json }

    example 'UPDATE : Updates group information' do
      explanation <<~DESC
        Updates and returns updated group.

        <b>MORE INFORMATION</b> :
        
          - See group attributes description in the section description.

        <b>NOTES</b> : 

          - This action allowed only for group owner user.
      DESC

      do_request

      expected_body = GroupSerializer
                        .new(student.reload.group)
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/group' do
    example "DELETE : Deletes user's group" do
      explanation <<~DESC
        Deletes a group.

        <b>NOTES</b> : 

          - This action allowed only for group owner user.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
