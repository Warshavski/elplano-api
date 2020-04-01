# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelsFinder do
  describe '#execute' do
    subject { described_class.new(context: owner, params: params).execute }

    let_it_be(:group) { create(:group) }

    let_it_be(:unexpected_label)          { create(:label, group: group) }
    let_it_be(:another_unexpected_label)  { create(:label) }

    let_it_be(:expected_label) do
      create(:label, title: 'wattest title', group: group)
    end

    let_it_be(:another_expected_label) do
      create(:label, description: 'wattest description', group: group)
    end

    context 'when owner is set' do
      let_it_be(:owner) { group }

      context 'when filters are not specified' do
        let_it_be(:params) { {} }

        it { is_expected.to eq([another_expected_label, expected_label, unexpected_label]) }
      end

      context 'when search filter is specified' do
        let_it_be(:params) { { search: 'wattest' } }

        it { is_expected.to eq([another_expected_label, expected_label]) }
      end
    end

    context 'when owner is not set' do
      let(:owner) { nil }

      context 'when filters are not specified' do
        let_it_be(:params) { {} }

        it { is_expected.to eq([another_expected_label, expected_label, another_unexpected_label, unexpected_label]) }
      end

      context 'when search filter is specified' do
        let_it_be(:params) { { search: 'wattest' } }

        it { is_expected.to eq([another_expected_label, expected_label]) }
      end
    end
  end
end
