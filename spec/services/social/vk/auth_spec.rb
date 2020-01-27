# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::Vk::Auth do
  subject do
    described_class
      .new(oauth_client, user: authenticated_user)
      .execute(code: code, redirect_uri: redirect_uri)
  end

  let(:authenticated_user) { nil }

  let(:email)         { Faker::Internet.email }
  let(:user_id)       { Faker::Omniauth.facebook[:uid] }
  let(:code)          { SecureRandom.hex(30) }
  let(:redirect_uri)  { Faker::Internet.url }

  let(:user_data) do
    {
      'user_id' => user_id,
      'email' => email,
      'expires_at' => Time.current + 30.minutes
    }
  end

  let(:existed_user)      { create(:user, :student, email: email) }
  let(:existed_identity)  { create(:identity, provider: :vk, uid: user_id) }

  let(:oauth_client) { spy }

  before do
    allow(oauth_client).to(
      receive_message_chain(:auth_code, :get_token)
        .with(code, redirect_uri: redirect_uri)
        .and_return(double('oauth_client', token: {}, params: user_data))
    )
  end

  it_behaves_like 'oauth login provider'
end
