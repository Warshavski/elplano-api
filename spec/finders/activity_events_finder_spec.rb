# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityEventsFinder do
  describe '#execute' do
    subject { described_class.new(owner: owner, params: params).execute }

    let_it_be(:assignment)  { create(:assignment) }
    let_it_be(:user)        { assignment.student.user }

    let_it_be(:first_event) do
      create(:activity_event, :created, author: user, target: assignment)
    end

    let_it_be(:last_event) do
      create(:activity_event, :updated, author: user, target: assignment)
    end

    let_it_be(:unexpected_event) do
      create(:activity_event, target: create(:assignment), action: :updated)
    end

    context 'when owner is set' do
      let(:owner) { user }

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

    context 'when owner is not set' do
      let(:owner) { nil }

      context 'when params are default(empty)' do
        let_it_be(:params) { {} }

        it { is_expected.to eq([unexpected_event, last_event, first_event]) }
      end

      context 'when valid author_id is set' do
        let_it_be(:params) { { author_id: user.id } }

        it { is_expected.to eq([last_event, first_event]) }
      end

      context 'when not valid author_id is set' do
        let_it_be(:params) { { author_id: 0 } }

        it { is_expected.to eq([]) }
      end

      context 'when valid action filter is set' do
        let_it_be(:params) { { action: 'updated' } }

        it { is_expected.to eq([unexpected_event, last_event]) }
      end
    end
  end
end
