# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { should belong_to(:task) }

    it { should belong_to(:student) }

    it { should have_many(:attachments).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:assignment) }

    it { should validate_uniqueness_of(:task_id).scoped_to(%i[student_id]) }
  end

  context 'scopes' do
    let_it_be(:student) { create(:student) }

    let_it_be(:accomplished_assignment) do
      create(:assignment, :accomplished, student: student)
    end

    let_it_be(:unfulfilled_assignment) do
      create(:assignment, :unfulfilled, student: student)
    end

    describe '.accomplished' do
      subject { described_class.accomplished }

      it { is_expected.to eq([accomplished_assignment]) }
    end

    describe '.unfulfilled' do
      subject { described_class.unfulfilled }

      it { is_expected.to eq([unfulfilled_assignment]) }
    end
  end
end
