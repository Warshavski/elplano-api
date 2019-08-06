# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Passwords::Change do
  describe '.call' do
    subject { described_class.call(user, password_params) }

    let_it_be(:user) { create(:user, password: '123456') }

    let_it_be(:password_params) do
      {
        current_password: '123456',
        password: '654321',
        password_confirmation: '654321'
      }
    end

    let_it_be(:current_password) { '123456' }
    let_it_be(:password) { '654321' }
    let_it_be(:password_confirmation) { '654321' }

    it { is_expected.to be true }

    context 'when current password is wrong' do
      let_it_be(:current_password) { 'wat_password' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

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
