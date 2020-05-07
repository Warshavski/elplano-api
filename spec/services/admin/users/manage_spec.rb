# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::Manage do
  let_it_be(:admin) { create(:user, :admin) }

  describe '#execute' do
    before do
      allow(Time).to(
        receive(:current).and_return(Time.parse('2019-08-14 00:00:00.000000000 +0000'))
      )
    end

    let(:instance) { described_class.new }

    subject { instance.execute(admin, user, action, opts) }

    let(:opts) { {} }

    context 'when one time action is performed' do
      context 'when action is a ban' do
        let_it_be(:user)  { create(:user) }
        let_it_be(:action) { :ban }

        it 'is expected to ban selected user' do
          is_expected.to eq(user)
          expect(user.banned_at).to eq('2019-08-14')
        end

        it_should_behave_like 'admin user management'
      end

      context 'when action is unban' do
        let_it_be(:user) { create(:user, :banned) }
        let_it_be(:action) { :unban }

        it 'is expected to unban selected user' do
          is_expected.to eq(user)
          expect(user.banned_at).to eq(nil)
        end

        it_should_behave_like 'admin user management'
      end

      context 'when action is confirm' do
        let_it_be(:user) { create(:user, :unconfirmed) }
        let_it_be(:action) { :confirm }

        it 'is expected to confirm user and set confirmed at date' do
          is_expected.to eq(user)

          expect(user.confirmed?).to be(true)
          expect(user.confirmed_at).not_to be(nil)
        end

        it_should_behave_like 'admin user management'
      end

      context 'when action is unlock' do
        let_it_be(:user) { create(:user, :locked) }
        let_it_be(:action) { :unlock }

        it 'is expected to unlock user access' do
          is_expected.to eq(user)

          expect(user.access_locked?).to be(false)
          expect(user.locked_at).to be(nil)
        end

        it_should_behave_like 'admin user management'
      end

      context 'when action is logout' do
        let_it_be(:user)    { create(:user) }
        let_it_be(:tokens)  { create_list(:token, 2, resource_owner_id: user.id) }

        let_it_be(:action) { :logout }

        it 'is expected to revoke all access tokens for user' do
          is_expected.to eq(user)

          tokens.each do |token|
            expect(token.reload.revoked?).to be(true)
          end
        end

        it_should_behave_like 'admin user management'
      end
    end

    context 'when action is reset password' do
      let_it_be(:user) { create(:user) }

      let(:opts) do
        { password: password, password_confirmation: password_confirmation }
      end

      let(:password) { 'P@$$w0rd' }
      let(:password_confirmation) { 'P@$$w0rd' }

      let_it_be(:action) { :reset_password }

      it "is expected to reset user's password" do
        mailer_stub = double('mailer', deliver_later: true)

        expect(Devise::Mailer).to receive(:password_change).and_return(mailer_stub)

        expect(Devise::Mailer).not_to receive(:reset_password_instructions)

        expect { subject }.to(change { user.reload.encrypted_password })
      end

      it_should_behave_like 'admin user management'

      context 'when new password is not valid' do
        let_it_be(:password) { '123' }
        let_it_be(:password_confirmation) { '123' }

        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context 'when password and password confirmation are not equal' do
        let_it_be(:password_confirmation) { '123' }

        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end
end
