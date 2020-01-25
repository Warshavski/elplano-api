# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::Google::Auth do
  subject do
    described_class.new(oauth_client).execute(code: code, redirect_uri: redirect_uri)
  end

  let(:email)         { Faker::Internet.email }
  let(:user_id)       { Faker::Omniauth.google[:uid] }
  let(:code)          { SecureRandom.hex(30) }
  let(:redirect_uri)  { 'postmessage' }

  let(:user_data) do
    { 'sub' => user_id, 'email' => email }
  end

  let(:existed_user)      { create(:user, :student, email: email) }
  let(:existed_identity)  { create(:identity, provider: :google, uid: user_id) }

  let(:oauth_client) { spy }

  before do
    allow(oauth_client).to(
      receive_message_chain(:auth_code, :get_token)
        .with(code, redirect_uri: redirect_uri)
        .and_return(double('oauth_client', token: 'code', get: double(:code, parsed: user_data)))
    )
  end

  it_behaves_like 'oauth login provider'
end
