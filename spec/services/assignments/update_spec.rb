# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignments::Update do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:course)  { create(:course, group: student.group) }

  let_it_be(:assignment) { create(:assignment, author: student, course: course) }

  let_it_be(:params) do
    {
      title: 'wat_title',
      description: 'wat_description',
      expired_at: Time.current + 1.day,
      course_id: course.id
    }
  end

  describe '.call' do
    subject { described_class.call(assignment, student, params) }

    it { is_expected.to eq(assignment) }

    it 'updated assignment attributes' do
      subject

      expect(assignment.title).to eq(params[:title])
      expect(assignment.description).to eq(params[:description])
    end

    context 'when course_id is not provided' do
      let_it_be(:params) { { title: 'wat_title' } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when course in not existed' do
      let_it_be(:params) { { title: 'wat_title', course_id: 0 } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when title is not provided' do
      let_it_be(:params) { { course_id: course.id } }

      it { expect { subject }.to not_change(assignment, :title) }
    end

    context 'when title is blank' do
      let_it_be(:params) { { title: '', course_id: course.id } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
