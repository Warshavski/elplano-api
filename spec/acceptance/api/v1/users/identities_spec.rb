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

        Identity attributes :
    
          - `provider` - Represents oauth provider name: #{Identity.providers.keys}
          - `timestamps`
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

        Users attributes :
    
          - `email` - Represents email that was used to register a user in the application(unique in application scope).
          - `username` - Represents used's user name.
          - `admin` - `false` if regular user `true`, if the user has access to application settings.
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
          - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
          - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
          - `locale` - Represents user's locale.
          - `avatar_url` - Represents user's avatar.
          - `timestamps`

        Student attributes :
      
          - `full_name` - Represents concatenated student's first, last and middle names.
          - `email` - Represents email which is used to contact with the student.
          - `phone` - Represents phone which is used to contact with the student.
          - `about` - Represents some detailed information about student(BIO).
          - `social_networks` - Represents a list of social networks.
          - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
          - `timestamps`

        Token attributes :

          - `access_token` - Represents access token(used to access API endpoints).
          - `refresh_token` - Represents refresh token(used to update expired access token).
          - `token_type` - Represents token type(always "Bearer").
          - `expires_in` - Represents expiration access token expiration time.
          - `created_at` - Represents access token creation date.

        Also, includes relationship to the student's group.
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

    example "INDEX : Get user's oauth providers list" do
      explanation <<~DESC
        Performs user authentication and returns authenticated user information.

        Identity attributes :
    
          - `provider` - Represents oauth provider name: #{Identity.providers.keys}
          - `timestamps`
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
