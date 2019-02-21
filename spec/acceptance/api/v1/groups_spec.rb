# frozen_string_literal: true

require 'acceptance_helper'

resource 'Groups' do
  explanation <<~DESC
    El Plano groups API'.

    Group attributes: 

      - `title` - Human readable group identity.
      - `number` - Main group identity.
      - timestamps

      Also, returns information about group members in relationships.
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
        Return detailed information about user's group.
      DESC

      do_request

      expected_body = GroupSerializer.new(group).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/group' do
    let_it_be(:student) { create(:student) }

    with_options scope: %i[dta attributes] do
      parameter :title, 'Human readable identity)', requred: true
      parameter :number, 'Main group identity', requred: true
    end

    let(:raw_post) { { data: build(:group_params) }.to_json }

    example 'CREATE : Creates new group' do
      explanation <<~DESC
        Create and return created group.
      DESC

      do_request

      expected_body = GroupSerializer
                        .new(student.reload.group)
                        .serialized_json
                        .to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  put 'api/v1/group' do
    with_options scope: %i[data attributes] do
      parameter :title, 'Human readable identity)', requred: true
      parameter :number, 'Main group identity', requred: true
    end

    let(:raw_post) { { data: build(:group_params) }.to_json }

    example 'UPDATE : Updates group information' do
      explanation <<~DESC
        Update and return updated group.
      DESC

      do_request

      expected_body = GroupSerializer
                        .new(student.reload.group)
                        .serialized_json
                        .to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/group' do
    example "DELETE : Deletes user's group" do
      explanation <<~DESC
        Delete group.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
