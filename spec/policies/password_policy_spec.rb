# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordPolicy do
  let_it_be(:user)   { build_stubbed(:user, password: '123456') }

  let(:policy)  { described_class.new(password, user: user) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when passwords are matched' do
      let_it_be(:password) { '123456' }

      it { is_expected.to eq(true) }
    end

    context 'when passwords are not matched' do
      let_it_be(:password) { 'wat_password?' }

      it { is_expected.to eq(false) }
    end
  end
end
