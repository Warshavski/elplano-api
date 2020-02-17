# frozen_string_literal: true

require 'acceptance_helper'

resource 'OAuth' do
  explanation <<~DESC
    El Plano OAuth API.
    
    Used to manage user's access tokens(claim, revoke)

    Token attributes :

      - `access_token` - Represents access token(used to access API endpoints).
      - `refresh_token` - Represents refresh token(used to update expired access token).
      - `token_type` - Represents token type(always "Bearer").
      - `expires_in` - Represents expiration access token expiration time.
      - `created_at` - Represents access token creation date.

    <b>MORE INFORMATION</b> : 

      - For more information see "Authentication" section in this documentation.
  DESC

  let_it_be(:user)  { create(:user, password: '123456') }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  post 'oauth/token' do
    parameter :grant_type, 'Token grant type. `password` - for first time claim and `refresh_token` - for access token refresh ', required: true
    parameter :login, "Users's email or username that used to identify user in application(used only for first time token claim)", required: true
    parameter :password, "User's password(used only for first time token claim)", required: true
    parameter :refresh_token, "Refresh token used to claim new access token(used in case if you have refresh token and need to obtain new access token)", required: true

    let(:raw_post) do
      {
        grant_type: 'password',
        login: user.email,
        password: '123456'
      }.to_json
    end

    example "CREATE : Claim access token" do
      explanation <<~DESC
        Claims access and refresh tokens to access application.

        <b>MORE INFORMATION</b> : 

          - See attributes description in the section description.
      DESC

      do_request

      token = user.recent_access_token

      expected_token = {
        access_token: token.token,
        token_type: 'Bearer',
        expires_in: token.expires_in,
        refresh_token: token.refresh_token,
        created_at: token.created_at.to_i
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_token.to_json)
    end
  end

  post 'oauth/revoke' do
    let_it_be(:token) { create(:token, resource_owner_id: user.id) }

    parameter :token, 'Access token to be revoked', required: true

    let(:raw_post) do
      { token: token.token }.to_json
    end

    example 'CREATE : Revoke access token' do
      explanation <<~DESC
        Revokes access token.
  
        <b>NOTE</b> : 

          - After this action user can not access application with this access token.
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq({}.to_json)
    end
  end
end
