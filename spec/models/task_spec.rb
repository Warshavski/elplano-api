# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it do
      should belong_to(:author)
               .class_name('Student')
               .with_foreign_key(:author_id)
               .inverse_of(:authored_tasks)
    end

    it { should belong_to(:event) }

    it do
      should have_many(:appointments)
               .class_name('Assignment')
               .inverse_of(:task)
               .dependent(:delete_all)
    end

    it { should have_many(:students).through(:appointments) }

    it { should have_many(:attachments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }

    it do
      expect(described_class::EXPIRATION_SCOPES).to(
        match_array(%w[outdated active today tomorrow upcoming])
      )
    end
  end

  context 'scopes' do
    context 'expiration' do
      before do
        allow(Date).to receive(:current).and_return(current_date)
      end

      let_it_be(:current_date) { Date.parse('2019-09-30') }

      let_it_be(:student) { create(:student, :group_supervisor) }
      let_it_be(:event)  { create(:event, eventable: student.group) }

      let_it_be(:expired) do
        create(:task, :skip_validation, event: event, author: student, expired_at: current_date - 1.day)
      end

      let_it_be(:active) do
        create(:task, :skip_validation, event: event, author: student, expired_at: current_date + 3.days)
      end

      let_it_be(:without_expiration) do
        create(:task, event: event, author: student, expired_at: nil)
      end

      let_it_be(:today) do
        create(:task, :skip_validation, event: event, author: student, expired_at: current_date)
      end

      let_it_be(:tomorrow) do
        create(:task, :skip_validation, event: event, author: student, expired_at: current_date + 1.day)
      end

      describe '.outdated' do
        subject { described_class.outdated }

        it { is_expected.to eq([expired]) }
      end

      describe '.active' do
        subject { described_class.active }

        it { is_expected.to eq([active, without_expiration, today, tomorrow]) }
      end

      describe '.today' do
        subject { described_class.today }

        it { is_expected.to eq([today])}
      end

      describe '.tomorrow' do
        subject { described_class.tomorrow }

        it { is_expected.to eq([tomorrow]) }
      end

      describe '.upcoming' do
        subject { described_class.upcoming }

        it { is_expected.to eq([active]) }
      end
    end
  end

  describe '#outdated?' do
    before do
      allow(Date).to receive(:current).and_return(Date.parse('2019-09-30'))
    end

    subject { task.outdated? }

    context 'when task is outdated' do
      let_it_be(:task) { build(:task, expired_at: '2019-09-29') }

      it { is_expected.to be(true) }
    end

    context 'when task is actual' do
      let_it_be(:task) { build(:task, expired_at: '2019-10-01') }

      it { is_expected.to be(false) }
    end

    context 'when task has no expiration date' do
      let_it_be(:task) { build(:task) }

      it { is_expected.to be(false) }
    end
  end
end
