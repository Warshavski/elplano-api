# frozen_string_literal: true

require 'acceptance_helper'

resource 'Groups' do
  explanation 'El Plano groups API'

  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:student) { create(:student, :group_supervisor) }
  let(:group)   { student.group }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/group' do
    context 'Authorized - 200' do
      example "SHOW : Retrieve information about user's group" do
        explanation <<~DESC
          Returns detailed information about user's group

          `title` - Human readable group identity
          `number` - Main group identity
          timestamps

          Also, returns information about group members in relationships
        DESC

        do_request

        expected_body = GroupSerializer.new(group).serialized_json.to_s

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
  end

  post 'api/v1/group' do
    let(:student) { create(:student) }

    context 'Authorized - 201' do
      with_options scope: %i[dta attributes] do
        parameter :title, 'Human readable identity)', requred: true
        parameter :number, 'Main group identity', requred: true
      end

      let(:raw_post) { { data: build(:group_params) }.to_json }

      example 'CREATE : Creates new group' do
        explanation <<~DESC
          Create and return created group
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

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'CREATE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Missing parameters - 400' do
      example 'CREATE : Returns 400 status code' do
        explanation <<~DESC
          Returns 400 status code in case of missing parameters
        DESC

        do_request

        expect(status).to eq(400)
      end
    end

    context 'Invalid parameters - 422' do
      let(:raw_post) do
        { data: build(:invalid_group_params) }.to_json
      end

      example 'CREATE : Returns 422 status code' do
        explanation <<~DESC
          Returns 422 status code in case of invalid parameters
        DESC

        do_request

        expect(status).to eq(422)
      end
    end

    context 'Access denied - 403' do
      let(:student) { create(:student, :group_member) }

      example 'CREATE : Returns 403 status code' do
        explanation <<~DESC
          Returns 403 status code in case in user has no access to action
        DESC

        do_request

        expect(status).to eq(403)
      end
    end
  end

  put 'api/v1/group' do
    context 'Authorized - 200' do
      with_options scope: %i[data attributes] do
        parameter :title, 'Human readable identity)', requred: true
        parameter :number, 'Main group identity', requred: true
      end

      let(:raw_post) { { data: build(:group_params) }.to_json }

      example 'UPDATE : Updates group information' do
        explanation <<~DESC
          Update and return updated group
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

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'UPDATE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Missing parameters - 400' do
      example 'UPDATE : Returns 400 status code' do
        explanation <<~DESC
          Returns 400 status code in case of missing parameters
        DESC

        do_request

        expect(status).to eq(400)
      end
    end

    context 'Invalid parameters - 422' do
      let(:raw_post) do
        { data: build(:invalid_group_params) }.to_json
      end

      example 'UPDATE : Returns 422 status code' do
        explanation <<~DESC
          Returns 422 status code in case of invalid parameters
        DESC

        do_request

        expect(status).to eq(422)
      end
    end

    context 'Access denied - 403' do
      let(:student) { create(:student, :group_member) }

      example 'UPDATE : Returns 403 status code' do
        explanation <<~DESC
          Returns 403 status code in case in user has no access to action
        DESC

        do_request

        expect(status).to eq(403)
      end
    end
  end

  delete 'api/v1/group' do
    context 'Authorized - 200' do
      example "DELETE : Deletes user's group" do
        explanation <<~DESC
          Deletes group
        DESC

        do_request

        expect(status).to eq(204)
      end
    end

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'DELETE : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end

    context 'Access denied - 403' do
      let(:student) { create(:student, :group_member) }

      example 'DELETE : Returns 403 status code' do
        explanation <<~DESC
          Returns 403 status code in case in user has no access to action
        DESC

        do_request

        expect(status).to eq(403)
      end
    end
  end
end
