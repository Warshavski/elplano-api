# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Status::Manage do
  describe '.call' do
    subject { described_class.call(action, user, opts) }

    let(:user) { create(:user) }
    let(:opts) { { message:  'wat', emoji: 'dog' } }

    context 'when action is upsert' do
      let(:action)  { :upsert }

      context 'when user has no status' do
        it 'is expected to create a new user status' do
          expect { subject }.to change(UserStatus, :count).by(1)

          expect(subject.message).to eq(opts[:message])
          expect(subject.emoji).to eq(opts[:emoji])
          expect(subject.user).to eq(user)
        end
      end

      context 'when user already has a status' do
        let!(:user_status) { create(:user_status, user: user) }

        it 'is expected to update status with new message and emoji' do
          expect { subject }.not_to change(UserStatus, :count)

          expect(subject.message).to eq(opts[:message])
          expect(subject.emoji).to eq(opts[:emoji])
          expect(subject.user).to eq(user)
        end
      end
    end

    context 'when action is destroy' do
      let(:action) { 'destroy' }

      let!(:random_status) { create(:user_status) }

      context 'when user has status' do
        let!(:user_status) { create(:user_status, user: user) }

        it 'is expected to remove user status' do
          expect { subject }.to change(UserStatus, :count).by(-1)

          expect(user.reload.status).to be(nil)
        end
      end

      context 'when user has no status' do
        it 'is expected to do nothing' do
          expect { subject }.not_to change(UserStatus, :count)
        end
      end
    end
  end
end
