# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  let(:user)  { create(:user, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  let(:identity)  { create(:identity, user: user) }
  let(:id)        { identity.id }

  get 'api/v1/users/identities' do
    header 'Authorization', :authorization

    let!(:identities) { [identity] }

    example "INDEX : Get user's oauth providers list" do
      explanation <<~DESC
        Performs user authentication and returns authenticated user information.

        #{Descriptions::Model.identity}
      DESC

      do_request

      expected_body = ::IdentitySerializer.new(identities).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/users/identities' do
    with_options scope: %i[identity] do
      parameter :code, 'Access token returned by social provider',
                required: true

      parameter :provider, "Type of social login provider: #{Identity.providers.keys}",
                required: true

      parameter :redirect_uri, 'Address to redirect user after authorization. Same as used by client',
                required: true
    end

    let(:raw_post) do
      {
        identity: {
          provider: 'google',
          code: code,
          redirect_uri: Faker::Internet.url
        }
      }.to_json
    end

    let(:code) { Faker::Omniauth.google[:uid] }
    let(:identity) { create(:identity) }

    before do
      allow(Social::Google::Auth).to receive(:call).and_return(identity)
    end

    example 'CREATE : Authenticate user via social provider' do
      explanation <<~DESC
        Performs user authentication and returns authenticated user information.

        #{Descriptions::Model.user}

        #{Descriptions::Model.student}

        #{Descriptions::Model.access_token}

        <b>NOTES</b>

          - Also, includes relationship to the student's group.
      DESC

      do_request

      options = { include: %i[recent_access_token student] }

      expected_body = ::Auth::UserSerializer.new(identity.user, options).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/users/identities/:id' do
    header 'Authorization', :authorization

    example "DELETE : Remove(unlink) user's oauth identity" do
      explanation <<~DESC
        Remove(unlink) OAuth provider identity
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
