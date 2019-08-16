# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  let_it_be(:user) { create(:user, :reset_password) }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  post 'api/v1/users/password' do
    with_options scope: %i[user] do
      parameter :email, 'Unique email that used to identify user in application or username.', required: true
    end

    let(:raw_post) do
      { user: { email: user.email } }.to_json
    end

    example 'CREATE : Send reset password instructions' do
      explanation <<~DESC
        Create reset password token and send reset password instructions to the specified email address.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end

  patch 'api/v1/users/password' do
    with_options scope: %i[user] do
      parameter :password, 'Password that the user uses to log in', required: true
      parameter :password_confirmation, 'Password duplicate. Used to prevent typos when entering a password', required: true
      parameter :reset_password_token, 'Unique token from email', required: true
    end

    let(:raw_post) do
      {
        user: {
          password: 'aA@123456',
          password_confirmation: 'aA@123456',
          reset_password_token: 'token'
        }
      }.to_json
    end

    example 'UPDATE : Reset password' do
      explanation <<~DESC
        Updates the user's password by changing it to the new one provided by a user.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'Your password has been changed successfully.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
