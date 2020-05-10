# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::Update do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:event)   { create(:event, eventable: student.group, creator: student) }

  let_it_be(:classmates)        { create_list(:student, 2, group: student.group) }
  let_it_be(:extra_classmates)  { create_list(:student, 2, group: student.group) }
  let_it_be(:random_students)   { create_list(:student, 2) }

  let(:task) { create(:task, author: student, event: event, students: classmates) }

  let_it_be(:valid_params) do
    {
      title: 'wat_title',
      description: 'wat_description',
      expired_at: Time.current + 1.day,
      event_id: event.id
    }
  end

  describe '.call' do
    subject { described_class.call(task, student, params) }

    let(:params) { valid_params }

    it 'is expected to update task attributes' do
      is_expected.to eq(task)

      expect(task.title).to eq(params[:title])
      expect(task.description).to eq(params[:description])
      expect(task.students).to match_array(classmates)
    end

    it { expect { subject }.to(change(ActivityEvent, :count).by(1)) }

    context 'when event_id is not provided' do
      let(:params) { { title: 'wat_title' } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when event in not existed' do
      let(:params) { { title: 'wat_title', event_id: 0 } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when title is not provided' do
      let(:params) { { event_id: event.id } }

      it { expect { subject }.to not_change(task, :title) }
    end

    context 'when title is blank' do
      let(:params) { { title: '', event_id: event.id } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when classmates are provided' do
      let(:params) { valid_params.merge(student_ids: extra_classmates.pluck(:id)) }

      it 'is expected to replace task appointments with new ones' do
        expect(subject.students).to match_array(extra_classmates)
      end
    end

    context 'when random students are provided' do
      let(:params) { valid_params.merge(student_ids: random_students.pluck(:id)) }

      it 'is expected to not update task appointments' do
        expect(subject.students).to match_array(classmates)
      end
    end

    context 'when classmates are not provided' do
      let(:params) { valid_params.merge(student_ids: []) }

      it 'is expected to remove task appointments' do
        expect(subject.students).to eq([])
      end
    end

    context 'when author is not a group owner' do
      subject { described_class.call(task, regular_member, params) }

      let_it_be(:regular_member) { create(:student, group: student.group) }
      let_it_be(:event) { create(:event, eventable: regular_member, creator: regular_member) }
      let_it_be(:task) { create(:task, author: regular_member) }

      let(:params) do
        {
          title: 'wat_title',
          description: 'wat_description',
          expired_at: Time.current + 1.day,
          event_id: event.id,
          student_ids: classmate_ids
        }
      end

      context 'when task is self assigned' do
        let(:classmate_ids) { [regular_member] }

        it 'is expected to update self assigned task' do
          is_expected.to eq(task)

          expect(task.title).to eq(params[:title])
          expect(task.description).to eq(params[:description])
          expect(task.students).to match_array([regular_member])
        end
      end

      context 'when task is not self assigned' do
        let(:classmate_ids) { [student.id] }

        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end
end
