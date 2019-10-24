# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbuseReportsFinder do
  describe '#execute' do
    subject { described_class.new(params).execute }

    let_it_be(:first_report) { create(:abuse_report) }
    let_it_be(:last_report)  { create(:abuse_report) }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([last_report, first_report]) }
    end

    context 'when user_id is presented and user exists' do
      let_it_be(:params) { { user_id: first_report.user_id } }

      it { is_expected.to eq([first_report]) }
    end

    context 'when user_id is presented and user not exists' do
      let_it_be(:params) { { user_id: 0 } }

      it { is_expected.to eq([]) }
    end

    context 'when reporter_id is presented and user exists' do
      let_it_be(:params) { { reporter_id: last_report.reporter_id } }

      it { is_expected.to eq([last_report]) }
    end

    context 'when reporter_id is presented and user not exists' do
      let_it_be(:params) { { reporter_id: 0 } }

      it { is_expected.to eq([]) }
    end
  end
end
