# frozen_string_literal: true

require 'acceptance_helper'

resource "User's Invites" do
  explanation <<~DESC
    El Plano user's invites API.

    #{Descriptions::Model.invite}

    #{Descriptions::Model.group}

    <b>NOTES</b> :

      - Also, includes reference to the sender, recipient.
  DESC

  let(:user)  { student.user }
  let(:access_token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{access_token}" }

  let(:student) { create(:student) }
  let(:invite)  { create(:invite, :rnd_group, email: user.email) }
  let(:token)   { invite.invitation_token }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/invites' do
    let!(:invites) { create_list(:invite, 1, :rnd_group, email: user.email) }

    example 'INDEX : Retrieve invites for authenticated user' do
      explanation <<~DESC
        Returns a list of invitations to the different groups.

        <b>MORE INFORMATION</b> :
        
          - See invite attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer
                        .new(invites, include: [:group], params: { exclude: [:students] })
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/invites/:token' do
    example 'SHOW : Retrieve information about requested invite' do
      explanation <<~DESC
        Returns a single instance of the invite.
        
        <b>MORE INFORMATION</b> :
        
          - See invite attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer
                        .new(invite, include: [:group], params: { exclude: [:students] })
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  patch 'api/v1/invites/:token' do
    example 'UPDATE : Accept selected invite' do
      explanation <<~DESC
        Accepts and returns accepted invite.

        <b>MORE INFORMATION</b> :
        
          - See invite attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer.new(invite.reload).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
