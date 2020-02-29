# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityEventsFinder do
  describe '#execute' do
    subject { described_class.new(user, params).execute }

    let_it_be(:assignment)  { create(:assignment) }
    let_it_be(:user)        { assignment.student.user }

    let_it_be(:first_event) do
      create(:activity_event, :created, author: user, target: assignment)
    end

    let_it_be(:last_event) do
      create(:activity_event, :updated, author: user, target: assignment)
    end

    let_it_be(:unexpected_event) { create(:activity_event, target: create(:assignment)) }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([last_event, first_event]) }
    end

    context 'when valid action filter is set' do
      let_it_be(:params) { { action: 'created' } }

      it { is_expected.to eq([first_event]) }
    end

    context 'when not valid action filter is set' do
      let_it_be(:params) { { action: 'wat' } }

      it { is_expected.to eq([]) }
    end
  end
end
