# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentsFinder do
  describe '#execute' do
    before do
      allow(Time).to receive(:current).and_return(Time.parse('2019-09-30 00:00:00 UTC'))
    end

    let_it_be(:author)  { create(:student) }
    let_it_be(:student) { create(:student) }
    let_it_be(:group)   { create(:group, president: author, students: [author, student]) }

    let_it_be(:course) { create(:course, group: group) }
    let_it_be(:additional_course) { create(:course, group: group) }
    let_it_be(:extra_course) { create(:course) }

    let_it_be(:active_assignment)  do
      create(:assignment, :skip_validation, author: author, course: course, expired_at: '2019-10-02')
    end

    let_it_be(:outdated_assignment) do
      create(:assignment, :skip_validation, author: author, course: additional_course, expired_at: '2019-09-29')
    end

    let_it_be(:extra_assignment) { create(:assignment) }

    subject { described_class.new(student, params).execute }

    context 'when empty params are provided' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([outdated_assignment, active_assignment]) }
    end

    context 'when course id is in student scope' do
      let_it_be(:params) { { course_id: course.id } }

      it { is_expected.to eq([active_assignment]) }
    end

    context 'when course id is out of the student scope' do
      let_it_be(:params) { { course_id: extra_course.id } }

      it { is_expected.to eq([]) }
    end

    context 'when outdated param is equal true' do
      let_it_be(:params) { { outdated: true } }

      it { is_expected.to eq([outdated_assignment]) }
    end

    context 'when outdated param is equal false' do
      let_it_be(:params) { { outdated: false } }

      it { is_expected.to eq([active_assignment]) }
    end

    context 'when outdated param is not valid' do
      let_it_be(:params) { { outdated: 'false' } }

      it { is_expected.to eq([]) }
    end
  end
end
