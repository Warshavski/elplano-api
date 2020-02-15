# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::Compose do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:event)   { create(:event, eventable: student.group, creator: student) }

  let_it_be(:params) do
    {
      title: 'wat title',
      description: 'wat description',
      expired_at: '2019-10-01'
    }
  end

  describe '.call' do
    subject { described_class.call(student, params) }

    context 'when event_id is not provided' do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when event is not exists' do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when event_id is valid and event exists' do
      let_it_be(:valid_params) { { event_id: event.id, title: 'wat' } }

      let(:params) { valid_params }

      it { is_expected.to eq({ event: event, author: student, title: 'wat' }) }

      context 'when classmates are provided' do
        let_it_be(:classmates) { create_list(:student, 2, group: student.group) }

        let(:params) { valid_params.merge(student_ids: classmates.pluck(:id)) }

        it 'is expected to build attributes with classmates' do
          attributes = subject
          students = attributes.delete(:students)

          expect(attributes).to eq({ event: event, author: student, title: 'wat' })
          expect(students).to match_array(classmates)
        end
      end

      context 'when random students are provided' do
        let_it_be(:students) { create_list(:student, 2) }

        let(:params) { valid_params.merge(student_ids: students.pluck(:id)) }

        it { is_expected.to eq({ event: event, author: student, title: 'wat' }) }
      end

      context 'when classmates are not provided' do
        let(:params) { valid_params.merge(student_ids: []) }

        it { is_expected.to eq({ event: event, author: student, title: 'wat', students: [] }) }
      end
    end
  end
end
