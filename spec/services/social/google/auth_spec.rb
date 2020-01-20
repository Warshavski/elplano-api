# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::Google::Auth do
  let(:email)     { Faker::Internet.email }
  let(:google_id) { Faker::Omniauth.google[:uid] }
  let(:token)     { SecureRandom.hex(30) }
  let(:audience)  { 'secret' }

  let(:user_data) do
    {
      user_id: google_id,
      email: email,
      expires_in: Time.current + 30.minutes,
      audience: audience
    }
  end

  let(:validator) { spy }

  before do
    stub = double('validator', user_data)
    allow(validator).to receive(:tokeninfo).and_return stub
    allow(ENV).to receive(:[]).with('GOOGLE_CLIENT_ID').and_return(audience)
  end

  subject { described_class.new(validator).execute(token) }

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

  context 'when provider respond without email' do
    let(:user_data) { { user_id: google_id, email: nil } }

    it 'is expected to raise an error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end

  context 'when provider respond with not expected audience' do
    let(:user_data) do
      {
        user_id: google_id,
        email: email,
        expires_in: Time.current + 30.minutes,
        audience: 'war audience'
      }
    end

    it 'is expected to raise an error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end

  context 'when token is expired' do
    let(:user_data) do
      {
        user_id: google_id,
        email: email,
        expires_in: Time.current - 30.minutes,
        audience: audience
      }
    end

    it 'is expected to raise an error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end

  context 'when provider request raises an error' do
    before do
      allow(validator).to(
        receive(:tokeninfo).with(access_token: token)
          .and_raise ::Google::Apis::ClientError.new('err')
      )
    end

    it 'is expected to reraise an api error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end
end
