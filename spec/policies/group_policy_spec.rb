# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupPolicy do
  let_it_be(:group_owner)   { create(:student, :group_supervisor) }
  let_it_be(:group_member)  { create(:student, :group_member) }
  let_it_be(:student)       { create(:student) }

  let_it_be(:group)   { build_stubbed(:group) }

  let(:policy)  { described_class.new(group, context) }

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when student has no group' do
      let_it_be(:context) { { student: student, user: student.user } }

      it { is_expected.to eq(true) }
    end

    context 'when student is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user } }

      it { is_expected.to eq(false) }
    end

    context 'when student is a regular group member' do
      let_it_be(:context) { { student: group_member, user: group_member.user } }

      it { is_expected.to eq(false) }
    end
  end

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when student is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user } }

      it { is_expected.to eq(true) }
    end

    context 'when student is a regular group member' do
      let_it_be(:context) { { student: group_member, user: group_member.user } }

      it { is_expected.to eq(false) }
    end
  end
end
