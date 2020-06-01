# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersFinder do
  describe '#execute' do
    subject { described_class.new(params: { filter: params }).execute }

    let_it_be(:confirmed_user)    { create(:user) }
    let_it_be(:unconfirmed_user)  { create(:user, :unconfirmed) }
    let_it_be(:banned_user)       { create(:user, :banned) }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([banned_user, unconfirmed_user, confirmed_user]) }
    end

    context 'when status filter is equal banned' do
      let_it_be(:params) { { status: :banned } }

      it { is_expected.to eq([banned_user]) }
    end

    context 'when status filter is equal confirmed' do
      let_it_be(:params) { { status: :confirmed } }

      it { is_expected.to eq([banned_user, confirmed_user]) }
    end

    context 'when status filter is equal active' do
      let_it_be(:params) { { status: :active } }

      it { is_expected.to eq([unconfirmed_user, confirmed_user]) }
    end

    context 'when search filter is specified' do
      let_it_be(:params) { { search: unconfirmed_user.email } }

      it { is_expected.to eq([unconfirmed_user]) }
    end
  end
end
