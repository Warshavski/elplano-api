# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignments::Compose do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:course)  { create(:course, group: student.group) }

  let_it_be(:params) do
    {
      title: 'wat title',
      description: 'wat description',
      expired_at: '2019-10-01'
    }
  end

  describe '.call' do
    subject { described_class.call(student, params) }

    context 'when course_id is not provided' do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when course is not exists' do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when course_id is valid and course exists' do
      let_it_be(:params) do
        { course_id: course.id, title: 'wat' }
      end

      it { is_expected.to eq({ course: course, author: student, title: 'wat' }) }
    end
  end
end
