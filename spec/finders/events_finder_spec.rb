# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsFinder do
  let_it_be(:member) { create(:student) }
  let_it_be(:president) { create(:student, :president) }

  let_it_be(:group) do
    create(:group, president: president, students: [president, member])
  end

  let_it_be(:personal_event) do
    create(:event, creator: president, eventable: member)
  end

  let_it_be(:group_event) do
    create(:event, creator: president, eventable: president.group)
  end

  describe '#execute' do
    subject { described_class.new(student, params).execute }

    context 'when student is a group president' do
      let_it_be(:student) { president }

      context 'when params are default(empty)' do
        let_it_be(:params) { {} }

        it { is_expected.to eq([group_event]) }
      end

      context 'when scope param is authored' do
        let_it_be(:params) { { scope: 'authored' } }

        it { is_expected.to eq([group_event, personal_event]) }
      end

      context 'when scope param is appointed' do
        let_it_be(:params) { { scope: 'appointed' } }

        it { is_expected.to eq([group_event]) }
      end

      context 'when type params is group' do
        let_it_be(:params) { { type: 'group' } }

        it { is_expected.to eq([group_event]) }
      end

      context 'when type params is personal' do
        let_it_be(:params) { { type: 'personal' } }

        it { is_expected.to eq([]) }
      end

      context 'when type params is personal and scope is appointed' do
        let_it_be(:params) { { type: 'personal', scope: 'appointed' } }

        it { is_expected.to eq([]) }
      end

      context 'when type params is group and scope is appointed' do
        let_it_be(:params) { { type: 'group', scope: 'appointed' } }

        it { is_expected.to eq([group_event]) }
      end

      context 'when type params is personal and scope is authored' do
        let_it_be(:params) { { type: 'personal', scope: 'authored' } }

        it { is_expected.to eq([personal_event]) }
      end

      context 'when type params is group and scope is authored' do
        let_it_be(:params) { { type: 'group', scope: 'authored' } }

        it { is_expected.to eq([group_event]) }
      end
    end

    context 'when student is a regular member' do
      let_it_be(:student) { member }

      context 'when params are default(empty)' do
        let_it_be(:params) { {} }

        it { is_expected.to eq([group_event, personal_event]) }
      end

      context 'when scope param is authored' do
        let_it_be(:params) { { scope: 'authored' } }

        it { is_expected.to eq([]) }
      end

      context 'when scope param is appointed' do
        let_it_be(:params) { { scope: 'appointed' } }

        it { is_expected.to eq([group_event, personal_event]) }
      end

      context 'when type params is group' do
        let_it_be(:params) { { type: 'group' } }

        it { is_expected.to eq([group_event]) }
      end

      context 'when type params is personal' do
        let_it_be(:params) { { type: 'personal' } }

        it { is_expected.to eq([personal_event]) }
      end

      context 'when type params is personal and scope is appointed' do
        let_it_be(:params) { { type: 'personal', scope: 'appointed' } }

        it { is_expected.to eq([personal_event]) }
      end

      context 'when type params is group and scope is appointed' do
        let_it_be(:params) { { type: 'group', scope: 'appointed' } }

        it { is_expected.to eq([group_event]) }
      end

      context 'when type params is personal and scope is authored' do
        let_it_be(:params) { { type: 'personal', scope: 'authored' } }

        it { is_expected.to eq([]) }
      end

      context 'when type params is group and scope is authored' do
        let_it_be(:params) { { type: 'group', scope: 'authored' } }

        it { is_expected.to eq([]) }
      end
    end
  end
end
