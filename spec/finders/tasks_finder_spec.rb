# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksFinder do
  describe '#execute' do
    before do
      allow(Date).to receive(:current).and_return(current_date)
    end

    let_it_be(:current_date) { Date.parse('2019-09-30') }

    let_it_be(:author)  { create(:student) }
    let_it_be(:student) { create(:student) }
    let_it_be(:group)   { create(:group, president: author, students: [author, student]) }

    let_it_be(:event)             { create(:event, eventable: group, creator: author) }
    let_it_be(:additional_event)  { create(:event, eventable: group, creator: author) }
    let_it_be(:extra_event)       { create(:event) }

    let_it_be(:active_task)  do
      create(:task, :skip_validation, author: author, event: event, expired_at: current_date + 3.days)
    end

    let_it_be(:outdated_task) do
      create(:task, :skip_validation, author: author, event: additional_event, expired_at: current_date - 1.day)
    end

    let_it_be(:today_task) do
      create(:task, :skip_validation, event: event, author: author, expired_at: current_date)
    end

    let_it_be(:tomorrow_task) do
      create(:task, :skip_validation, event: event, author: author, expired_at: current_date + 1.day)
    end

    let_it_be(:extra_task) { create(:task) }

    let_it_be(:appointed_tasks) { create_list(:task, 2, students: [author]) }

    subject { described_class.new(context: author, params: { filter: params }).execute }

    context 'when empty params are provided' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([tomorrow_task, today_task, outdated_task, active_task]) }
    end

    context 'when event id is in student scope' do
      let_it_be(:params) { { event_id: event.id } }

      it { is_expected.to eq([tomorrow_task, today_task, active_task]) }
    end

    context 'when event id is out of the student scope' do
      let_it_be(:params) { { event_id: extra_event.id } }

      it { is_expected.to eq([]) }
    end

    context 'when expiration param is to outdated scope' do
      let_it_be(:params) { { expiration: :outdated } }

      it { is_expected.to eq([outdated_task]) }
    end

    context 'when expiration param is active scope' do
      let_it_be(:params) { { expiration: :active } }

      it { is_expected.to eq([tomorrow_task, today_task, active_task]) }
    end

    context 'when expiration param is set to today scope' do
      let_it_be(:params) { { expiration: :today } }

      it { is_expected.to eq([today_task]) }
    end

    context 'when expiration param is set to tomorrow scope' do
      let_it_be(:params) { { expiration: :tomorrow } }

      it { is_expected.to eq([tomorrow_task]) }
    end

    context 'when expiration param is set to upcoming scope' do
      let_it_be(:params) { { expiration: :upcoming } }

      it { is_expected.to eq([active_task]) }
    end

    context 'when expiration param is not valid' do
      let_it_be(:params) { { expiration: :wat } }

      it { is_expected.to eq([]) }
    end

    context 'when appointed param is equal to true' do
      let_it_be(:params) { { appointed: true } }

      it { is_expected.to eq(appointed_tasks.reverse) }
    end

    context 'when appointed param is equal to false' do
      let_it_be(:params) { { appointed: false } }

      it { is_expected.to eq([tomorrow_task, today_task, outdated_task, active_task]) }
    end

    context 'when appointed param is not valid' do
      let_it_be(:params) { { appointed: 'false' } }

      it { is_expected.to eq(appointed_tasks.reverse) }
    end

    context 'with accomplished params' do
      let_it_be(:accomplished_task) do
        create(
          :task, :accomplished, :skip_validation,
          author: author, event: event, expired_at: '2019-10-02'
        )
      end

      context 'when accomplished param is equal to true' do
        let_it_be(:params) { { accomplished: true } }

        it { is_expected.to eq([accomplished_task]) }
      end

      context 'when accomplished param is equal to false' do
        let_it_be(:params) { { accomplished: false } }

        it { is_expected.to eq(appointed_tasks.reverse) }
      end

      context 'when accomplished param is not valid' do
        let_it_be(:params) { { accomplished: 'false' } }

        it { is_expected.to eq([]) }
      end
    end
  end
end
