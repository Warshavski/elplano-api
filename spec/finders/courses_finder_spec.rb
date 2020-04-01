# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesFinder do
  let_it_be(:group)               { create(:group) }
  let_it_be(:active_course)       { create(:course, group: group, active: true) }
  let_it_be(:deactivated_course)  { create(:course, group: group, active: false) }

  describe '#execute' do
    subject { described_class.new(context: group, params: params).execute }

    context 'when active is set to true' do
      let_it_be(:params) { { active: true } }

      it { is_expected.to eq([active_course]) }
    end

    context 'when active is set to false' do
      let_it_be(:params) { { active: false } }

      it { is_expected.to eq([deactivated_course]) }
    end

    context 'when param are default {}' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([deactivated_course, active_course]) }
    end
  end
end
