# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::CoursePolicy do
  let(:course) { build_stubbed(:course) }
  let(:policy) { described_class.new(course, context) }

  let_it_be(:group_owner)   { create(:student, :group_supervisor) }
  let_it_be(:group_member)  { create(:student, :group_member) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when student is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user }  }

      it { is_expected.to be(true) }
    end

    context 'when student is a regular group member' do
      let_it_be(:context) { { student: group_member, user: group_member.user }  }

      it { is_expected.to be(false) }
    end
  end
end
