# frozen_string_literal: true

require 'acceptance_helper'

resource "Group's Invites" do
  explanation <<~DESC
    El Plano group's invites API.

    Invite attributes :

    - `email` - Represents email where invite was sent.
    - `invitation_token` - Represents token.
    - `status` - Represents invite current status.
      - `accepted` - The invite was accepted by the recipient.
      - `pending` - The invite was not accepted by the recipient. Default status.
    - `sent_at` - Date and time when the invite was sent.
    - `accepted_at` - Date and time when the invite was accepted by recipient.
    - `timestamps`

    <b>NOTES</b> : 

      - This endpoint allowed only for the group owner user.
      - Also, includes reference to the sender, recipient.
  DESC

  let!(:group) { create(:group, president: student, students: [student]) }

  let(:user)  { student.user }
  let(:access_token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{access_token}" }

  let(:student) { create(:student) }
  let(:invite)  { create(:invite, group: student.group) }
  let(:id)      { invite.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group/invites' do
    let!(:invites) { create_list(:invite, 1, group: student.group) }

    example "INDEX : Retrieve user's group invitations" do
      explanation <<~DESC
        Returns a list of the user group invitations.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer.new(invites).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/group/invites/:id' do
    example 'SHOW : Retrieve information about requested invite' do
      explanation <<~DESC
        Returns a single instance of the invite.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer.new(invite).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/group/invites' do
    with_options scope: %i[data attributes] do
      parameter :email, 'Email where invite should be send', required: true
    end

    let(:raw_post) { { invite: build(:invite_params) }.to_json }

    example 'CREATE : Create new invite' do
      explanation <<~DESC
        Creates and returns created invite.

        <b>MORE INFORMATION</b> :

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = InviteSerializer.new(Invite.first).serialized_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end
end
