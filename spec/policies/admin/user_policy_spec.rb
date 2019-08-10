# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UserPolicy do
  let_it_be(:regular_user)  { build_stubbed(:user) }
  let_it_be(:admin_user)    { build_stubbed(:admin) }

  let(:policy)  { described_class.new(User, context) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when user is a regular user' do
      let_it_be(:context) { { user: regular_user } }

      it { is_expected.to eq(false) }
    end

    context 'when user is an admin' do
      let_it_be(:context) { { user: admin_user } }

      it { is_expected.to eq(true) }
    end
  end
end
