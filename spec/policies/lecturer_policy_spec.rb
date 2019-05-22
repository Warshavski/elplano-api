# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LecturerPolicy do
  let(:lecturer)  { build_stubbed(:lecturer) }
  let(:policy)    { described_class.new(lecturer, user: user) }

  context 'when student is a group owner' do
    let_it_be(:user) { create(:student, :group_supervisor) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(true) }
    end

    describe '#update?' do
      subject { policy.apply(:update?) }

      it { is_expected.to eq(true) }
    end

    describe '#destroy?' do
      subject { policy.apply(:destroy?) }

      it { is_expected.to eq(true) }
    end
  end

  context 'when user is a regular group member' do
    let_it_be(:user) { create(:student, :group_member) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(false) }
    end

    describe '#update?' do
      subject { policy.apply(:update?) }

      it { is_expected.to eq(false) }
    end

    describe '#destroy?' do
      subject { policy.apply(:destroy?) }

      it { is_expected.to eq(false) }
    end
  end
end
