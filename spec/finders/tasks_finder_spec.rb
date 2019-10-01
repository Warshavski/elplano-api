# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksFinder do
  describe '#execute' do
    before do
      allow(Time).to receive(:current).and_return(Time.parse('2019-09-30 00:00:00 UTC'))
    end

    let_it_be(:author)  { create(:student) }
    let_it_be(:student) { create(:student) }
    let_it_be(:group)   { create(:group, president: author, students: [author, student]) }

    let_it_be(:event)             { create(:event, eventable: group, creator: author) }
    let_it_be(:additional_event)  { create(:event, eventable: group, creator: author) }
    let_it_be(:extra_event)       { create(:event) }

    let_it_be(:active_task)  do
      create(:task, :skip_validation, author: author, event: event, expired_at: '2019-10-02')
    end

    let_it_be(:outdated_task) do
      create(:task, :skip_validation, author: author, event: additional_event, expired_at: '2019-09-29')
    end

    let_it_be(:extra_task) { create(:task) }

    let_it_be(:appointed_tasks) { create_list(:task, 2, students: [author]) }

    subject { described_class.new(author, params).execute }

    context 'when empty params are provided' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([outdated_task, active_task]) }
    end

    context 'when event id is in student scope' do
      let_it_be(:params) { { event_id: event.id } }

      it { is_expected.to eq([active_task]) }
    end

    context 'when event id is out of the student scope' do
      let_it_be(:params) { { event_id: extra_event.id } }

      it { is_expected.to eq([]) }
    end

    context 'when outdated param is equal to true' do
      let_it_be(:params) { { outdated: true } }

      it { is_expected.to eq([outdated_task]) }
    end

    context 'when outdated param is equal to false' do
      let_it_be(:params) { { outdated: false } }

      it { is_expected.to eq([active_task]) }
    end

    context 'when outdated param is not valid' do
      let_it_be(:params) { { outdated: 'false' } }

      it { is_expected.to eq([]) }
    end

    context 'when appointed param is equal to true' do
      let_it_be(:params) { { appointed: true } }

      it { is_expected.to eq(appointed_tasks.reverse) }
    end

    context 'when appointed param is equal to false' do
      let_it_be(:params) { { appointed: false } }

      it { is_expected.to eq([outdated_task, active_task]) }
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
