# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Destroy do
  describe '.call' do
    subject { described_class.call(user) }

    let_it_be(:user) { create(:user) }

    it { expect { subject }.to change(User, :count).by(-1) }

    it { is_expected.to eq(user) }
  end
end
