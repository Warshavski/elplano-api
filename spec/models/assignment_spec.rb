# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  context 'scopes' do
    context 'expiration' do
      let_it_be(:student) { create(:student, :group_supervisor) }
      let_it_be(:course)  { create(:course, group: student.group) }

      let_it_be(:expired) do
        create(:assignment, :skip_validation, course: course, author: student, expired_at: '2019-09-29')
      end

      let_it_be(:active) do
        create(:assignment, course: course, author: student, expired_at: '2019-10-02')
      end

      let_it_be(:without_expiration) do
        create(:assignment, course: course, author: student, expired_at: nil)
      end

      before do
        allow(Time).to receive(:current).and_return(Time.parse('2019-09-30 00:00:00 UTC'))
      end

      describe '.outdated' do
        subject { described_class.outdated }

        it { is_expected.to eq([expired]) }
      end

      describe '.active' do
        subject { described_class.active }

        it { is_expected.to eq([active, without_expiration]) }
      end
    end
  end

  describe '#outdated?' do
    before do
      allow(Time).to receive(:current).and_return(Time.parse('2019-09-30 00:00:00 UTC'))
    end

    subject { assignment.outdated? }

    context 'when assignment is outdated' do
      let_it_be(:assignment) { build(:assignment, expired_at: '2019-09-29') }

      it { is_expected.to be(true) }
    end

    context 'when assignment is actual' do
      let_it_be(:assignment) { build(:assignment, expired_at: '2019-10-01') }

      it { is_expected.to be(false) }
    end

    context 'when assignment has no expiration date' do
      let_it_be(:assignment) { build(:assignment) }

      it { is_expected.to be(false) }
    end
  end
end
