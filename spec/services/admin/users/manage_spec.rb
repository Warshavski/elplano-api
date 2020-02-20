# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::Manage do
  describe '.call' do
    before do
      allow(Time).to(
        receive(:current).and_return(Time.parse('2019-08-14 00:00:00.000000000 +0000'))
      )
    end

    subject { described_class.call(user, action) }

    before(:each) { subject }

    context 'when action is a ban' do
      let_it_be(:user) { create(:user) }
      let(:action) { :ban }

      it { is_expected.to eq(user) }

      it 'sets banned at date' do

        expect(user.banned_at).to eq('2019-08-14')
      end
    end

    context 'when action is unban' do
      let_it_be(:user) { create(:user, :banned) }
      let(:action) { :unban }

      it { is_expected.to eq(user) }

      it 'removes banned at date' do
        expect(user.banned_at).to eq(nil)
      end
    end

    context 'when action is confirm' do
      let_it_be(:user) { create(:user, :unconfirmed) }
      let(:action) { :confirm }

      it { is_expected.to eq(user) }

      it 'confirms user and sets confirmed at date' do
        expect(user.confirmed?).to be(true)
        expect(user.confirmed_at).not_to be(nil)
      end
    end

    context 'when action is unlock' do
      let_it_be(:user) { create(:user, :locked) }
      let(:action) { :unlock }

      it { is_expected.to eq(user) }

      it 'unlocks user access and remove locked at date' do
        expect(user.access_locked?).to be(false)
        expect(user.locked_at).to be(nil)
      end
    end

    context 'when action is logout' do
      let_it_be(:user)    { create(:user) }
      let_it_be(:tokens)  { create_list(:token, 2, resource_owner_id: user.id) }

      let(:action) { :logout }

      it 'revokes all access tokens for user' do
        tokens.each do |token|
          expect(token.reload.revoked?).to be(true)
        end
      end
    end
  end
end
