# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Register do
  let(:user_params) do
    {
      username: 'wat name',
      email: 'wat@email.wat',
      password: '123456',
      password_confirmation: '123456'
    }
  end

  subject { described_class }

  describe '.call' do
    it 'creates a new user' do
      expect { subject.call(user_params) }.to change(User, :count).by(1)
    end

    it 'creates a new student' do
      expect { subject.call(user_params) }.to change(Student, :count).by(1)
    end

    it 'returns created user' do
      user = subject.call(user_params)

      expect(user.email).to eq(user_params[:email])
    end

    it 'creates student with same email as user' do
      user = subject.call(user_params)

      expect(user.student.email).to eq(user.email)
    end

    it 'creates user specified by block' do
      expect { subject.call { User.new(user_params) } }.to change(User, :count).by(1)
    end

    it 'creates user with params from block' do
      user = subject.call { User.new(user_params.merge(username: 'block user')) }

      expect(user.username).to eq('block user')
    end

    it 'throws validation error' do
      expect { subject.call { User.new(email: 'awt') } }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
