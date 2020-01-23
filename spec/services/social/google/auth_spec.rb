# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::Google::Auth do
  let(:email)     { Faker::Internet.email }
  let(:google_id) { Faker::Omniauth.google[:uid] }
  let(:code)     { SecureRandom.hex(30) }

  let(:redirect_uri) { 'postmessage' }

  let(:user_data) do
    {
      'sub' => google_id,
      'email' => email,
    }
  end

  let(:oauth_client) { spy }

  before do
    allow(oauth_client).to(
      receive_message_chain(:auth_code, :get_token)
        .with(code, redirect_uri: redirect_uri)
        .and_return(double('oauth_client', token: 'code', get: double(:code, parsed: user_data)))
    )
  end

  subject { described_class.new(oauth_client).execute(code: code) }

  context 'user registration' do
    it 'is expected to create a new user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'is expected to create a new identity' do
      expect { subject }.to change(Identity, :count).by(1)
    end

    it 'is expected to create a new student' do
      expect { subject }.to change(Student, :count).by(1)
    end

    it 'is expected to return an identity class' do
      expect(subject).to be_instance_of(Identity)
    end

    it 'is expected to not sent confirmation email' do
      expect { subject }.not_to(have_enqueued_job(ActionMailer::DeliveryJob))
    end
  end

  context 'existed user login' do
    let!(:user) { create(:user, :student, email: email) }

    it 'is expected to not create a new user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'is expected to create a new identity' do
      expect { subject }.to change(Identity, :count).by(1)
    end

    it 'is expected to return an identity instance' do
      expect(subject).to be_instance_of(Identity)
    end
  end

  context 'when user and identity is already exist' do
    let!(:user)      { create(:user, :student, email: email) }
    let!(:identity)  { create(:identity, provider: :google, uid: google_id) }

    it 'is expected to not create a new user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'is expected to not create a new identity' do
      expect { subject }.not_to change(Identity, :count)
    end

    it 'is expected to return identity instance' do
      is_expected.to be_instance_of(Identity)
    end
  end

  context 'when provider request raises an error' do
    before do
      allow(oauth_client).to(
        receive_message_chain(:auth_code, :get_token)
          .with(code, redirect_uri: redirect_uri)
          .and_raise OAuth2::Error.new(double('response', 'error=': {}, parsed: {}, body: '{}'))
      )
    end

    it 'is expected to reraise an api error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end
end
