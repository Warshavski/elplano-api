# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  let_it_be(:active_user)   { build_stubbed(:user) }
  let_it_be(:banned_user)   { build_stubbed(:user, banned_at: Time.current) }

  let(:policy)  { described_class.new(User, context) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when user has ban' do
      let_it_be(:context) { { user: banned_user } }

      it { is_expected.to eq(false) }
    end

    context 'when user has no ban' do
      let_it_be(:context) { { user: active_user } }

      it { is_expected.to eq(true) }
    end
  end
end
