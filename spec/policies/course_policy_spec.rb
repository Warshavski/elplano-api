# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursePolicy do
  let(:course) { build_stubbed(:course) }
  let(:policy) { described_class.new(course, student: student, user: student.user) }

  context 'when student is a group owner' do
    let_it_be(:student) { create(:student, :group_supervisor) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to be(true) }
    end

    describe '#update?' do
      subject { policy.apply(:update?) }

      it { is_expected.to be(true) }
    end

    describe '#destroy?' do
      subject { policy.apply(:destroy?) }

      it { is_expected.to be(true) }
    end
  end

  context 'when student is a regular group member' do
    let_it_be(:student) { create(:student, :group_member) }

    describe '#create?' do
      subject { policy.apply(:create?) }

      it { is_expected.to be(false) }
    end

    describe '#update?' do
      subject { policy.apply(:update?) }

      it { is_expected.to be(false) }
    end

    describe '#destroy?' do
      subject { policy.apply(:destroy?) }

      it { is_expected.to be(false) }
    end
  end
end
