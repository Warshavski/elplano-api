# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupPolicy do
  let(:group)   { build_stubbed(:group) }
  let(:policy)  { described_class.new(group, student: student, user: student.user) }

  context 'when a student has no group' do
    let_it_be(:student) { create(:student) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(true) }
    end
  end

  context 'when student is a group owner' do
    let_it_be(:student) { create(:student, :group_supervisor) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to eq(false) }
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

  context 'when student is a regular group member' do
    let_it_be(:student) { create(:student, :group_member) }

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
