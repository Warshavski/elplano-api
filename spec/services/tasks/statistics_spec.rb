require 'rails_helper'

RSpec.describe Tasks::Statistics do
  describe '.call' do
    subject { described_class.call(student) }

    before do
      allow(Date).to receive(:current).and_return(current_date)
    end

    let_it_be(:current_date) { Date.parse('2019-09-30') }

    let_it_be(:author)    { create(:student, :group_supervisor) }
    let_it_be(:student)   { create(:student, group: author.group) }
    let_it_be(:classmate) { create(:student, group: author.group) }
    let_it_be(:event)     { create(:event, eventable: student.group) }

    context 'when user has no tasks' do
      it 'is expected to return hash with zero counters' do
        expected_hash = {
          'outdated_count' => 0,
          'today_count' => 0,
          'tomorrow_count' => 0,
          'upcoming_count' => 0,
          'accomplished_count' => 0
        }

        is_expected.to eq(expected_hash)
      end
    end

    context 'when user has taks in different conditions' do
      let_it_be(:expired) do
        create_list(
          :task, 2, :skip_validation,
          event: event, author: author, students: [student, classmate], expired_at: current_date - 1.day
        )
      end

      let_it_be(:active) do
        create(
          :task, :skip_validation,
          event: event, author: author, students: [student, classmate], expired_at: current_date + 3.days
        )
      end

      let_it_be(:without_expiration) do
        create(:task, event: event, author: author, students: [student, classmate], expired_at: nil)
      end

      let_it_be(:today) do
        create_list(
          :task, 3, :skip_validation,
          event: event, author: author, students: [student, classmate], expired_at: current_date
        )
      end

      let_it_be(:tomorrow) do
        create(
          :task, :skip_validation,
          event: event, author: author, students: [student, classmate], expired_at: current_date + 1.day
        )
      end

      it 'is expected to return hash with grouped counters' do
        expected_hash = {
          'outdated_count' => 2,
          'today_count' => 3,
          'tomorrow_count' => 1,
          'upcoming_count' => 1,
          'accomplished_count' => 0
        }

        is_expected.to eq(expected_hash)
      end
    end
  end
end
