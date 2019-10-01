# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignments::Create do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:course)  { create(:course, group: student.group) }

  let_it_be(:params) { { title: 'wat_title', course_id: course.id } }

  describe '.call' do
    subject { described_class.call(student, params) }

    it { expect { subject }.to change(Assignment, :count).by(1) }

    it { is_expected.to be_an(Assignment) }

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

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when title is blank' do
      let_it_be(:params) { { title: '', course_id: course.id } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
