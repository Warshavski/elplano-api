# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Social::Vk::Auth do
  let(:email)         { Faker::Internet.email }
  let(:vk_id)         { Faker::Omniauth.facebook[:uid] }
  let(:token)         { SecureRandom.hex(30) }
  let(:redirect_uri)  { Faker::Internet.url }

  let(:user_data) do
    {
      user_id: vk_id,
      email: email,
      expires_at: Time.current + 30.minutes
    }
  end

  let(:validator) { spy }

  before do
    allow(validator).to(
      receive(:authorize)
        .with(code: token, redirect_uri: redirect_uri)
        .and_return(double('validator', user_data))
    )
  end

  subject do
    described_class.new(validator).execute(code: token, redirect_uri: redirect_uri)
  end

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
    let!(:identity)  { create(:identity, provider: :vk, uid: vk_id) }

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
    let(:user_data) { { user_id: vk_id, email: nil } }

    it 'is expected to raise an error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end

  context 'when provider request raises an error' do
    before do
      error_data = {
        error_code: 400,
        error_msg: 'error',
        captcha_sid: 'sid',
        captcha_img: 'img',
        request_params: {},
        redirect_uri: redirect_uri
      }

      allow(validator).to(
        receive(:authorize).with(code: token, redirect_uri: redirect_uri)
          .and_raise ::VkontakteApi::Error.new(double('data', error_data))
      )
    end

    it 'is expected to reraise an api error' do
      expect { subject }.to raise_error(Api::UnprocessableAuth)
    end
  end
end
