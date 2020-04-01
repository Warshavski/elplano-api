# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BugReportsFinder do
  describe '#execute' do
    subject { described_class.new(params: params).execute }

    let_it_be(:first_report) { create(:bug_report) }
    let_it_be(:last_report)  { create(:bug_report) }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([last_report, first_report]) }
    end

    context 'when user_id is presented and user exists' do
      let_it_be(:params) { { user_id: first_report.reporter_id } }

      it { is_expected.to eq([first_report]) }
    end

    context 'when user_id is presented and user not exists' do
      let_it_be(:params) { { user_id: 0 } }

      it { is_expected.to eq([]) }
    end
  end
end
