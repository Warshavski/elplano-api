# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsFinder do
  describe '#execute' do
    subject { described_class.new(params: params).execute }

    let_it_be(:first_group)  { create(:group, title: 'first', number: 'first') }
    let_it_be(:second_group) { create(:group, title: 'second', number: 'second') }

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([second_group, first_group]) }
    end

    context 'when search filter is specified' do
      context 'when search term is a title' do
        let_it_be(:params) { { search: first_group.title } }

        it { is_expected.to eq([first_group]) }
      end

      context 'when search term is a number' do
        let_it_be(:params) { { search: second_group.number } }

        it { is_expected.to eq([second_group]) }
      end
    end
  end
end
