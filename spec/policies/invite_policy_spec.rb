# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitePolicy do
  let(:invite) { build_stubbed(:invite) }
  let(:policy) { described_class.new(invite, user: user) }

  context 'when student is a group owner' do
    let_it_be(:user) { create(:student, :group_supervisor) }

    describe '#create?' do
      subject { policy.apply(:index?) }

      it { is_expected.to eq(true) }
    end

    describe '#update?' do
      subject { policy.apply(:show?) }

      it { is_expected.to eq(true) }
    end

    describe '#destroy?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(true) }
    end
  end

  context 'when user is a regular group member' do
    let_it_be(:user) { create(:student, :group_member) }

    describe '#create?' do
      subject { policy.apply(:index?) }

      it { is_expected.to eq(false) }
    end

    describe '#update?' do
      subject { policy.apply(:show?) }

      it { is_expected.to eq(false) }
    end

    describe '#destroy?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(false) }
    end
  end
end
