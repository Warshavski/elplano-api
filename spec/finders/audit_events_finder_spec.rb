# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditEventsFinder do
  describe '#execute' do
    subject { described_class.new(context: user, params: { filter: params }).execute }

    let_it_be(:user) { create(:user) }

    let_it_be(:first_event) { create(:audit_event, author: user, entity: user) }
    let_it_be(:last_event)  { create(:audit_event, author: user, entity: user) }

    let_it_be(:extra_event) do
      create(:audit_event, :permanent_action, author: user, entity: user)
    end

    let_it_be(:unexpected_event) { create(:audit_event) }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([extra_event, last_event, first_event]) }
    end

    context 'when valid type filter is set' do
      let_it_be(:params) { { type: 'authentication' } }

      it { is_expected.to eq([last_event, first_event]) }
    end

    context 'when not valid type filter is set' do
      let_it_be(:params) { { type: 'wat' } }

      it { is_expected.to eq([]) }
    end
  end
end
