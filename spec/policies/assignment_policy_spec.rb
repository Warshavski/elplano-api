# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentPolicy do
  let_it_be(:group_owner)     { create(:student, :group_supervisor) }
  let_it_be(:regular_member)  { create(:student, group: group_owner.group) }

  let_it_be(:course)      { build_stubbed(:course, group: group_owner.group)}
  let_it_be(:assignment)  { build_stubbed(:assignment, course: course, author: group_owner) }

  let(:policy) { described_class.new(assignment, context) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when user is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user } }

      it { is_expected.to eq(true) }
    end

    context 'when user is a regular group member' do
      let_it_be(:context) { { student: regular_member, user: regular_member.user } }

      it { is_expected.to eq(false) }
    end
  end

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'when user is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user } }

      it { is_expected.to eq(true) }
    end

    context 'when user is a regular group member' do
      let_it_be(:context) { { student: regular_member, user: regular_member.user } }

      it { is_expected.to eq(false) }
    end
  end
end
