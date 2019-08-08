# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventPolicy do
  let_it_be(:group_owner) { create(:student, :group_supervisor) }
  let_it_be(:classmate)   { create(:student, group: group_owner.group) }

  let(:policy)  { described_class.new(event, context) }

  describe '#manage?' do
    subject { policy.apply(:manage?) }

    context 'when event owner is a group owner' do
      let_it_be(:context) { { student: group_owner, user: group_owner.user } }

      context 'when event created for group' do
        let_it_be(:event) { build_stubbed(:event, eventable: group_owner.group) }

        it { is_expected.to eq(true) }
      end

      context 'when event created for self' do
        let_it_be(:event) { build_stubbed(:event, eventable: group_owner) }

        it { is_expected.to eq(true) }
      end

      context 'when event created for classmate' do
        let_it_be(:event) { build_stubbed(:event, eventable: classmate) }

        it { is_expected.to eq(true) }
      end
    end

    context 'when event owner is a regular group member' do
      let_it_be(:context) { { student: classmate, user: classmate.user } }

      context 'when event created for group' do
        let_it_be(:event) { build_stubbed(:event, eventable: classmate.group) }

        it { is_expected.to eq(false) }
      end

      context 'when event created for self' do
        let_it_be(:event) { build_stubbed(:event, eventable: classmate) }

        it { is_expected.to eq(true) }
      end

      context 'when event created for classmate' do
        let_it_be(:event) { build_stubbed(:event, eventable: group_owner) }

        it { is_expected.to eq(false) }
      end
    end
  end
end
