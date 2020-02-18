# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    it { should belong_to(:president).class_name('Student') }

    it { should have_many(:students).dependent(:nullify) }

    it { should have_many(:invites).dependent(:destroy) }

    it { should have_many(:lecturers).dependent(:destroy) }

    it { should have_many(:events).dependent(:destroy) }

    it { should have_many(:labels).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:number) }

    it { should validate_length_of(:number).is_at_most(25) }

    it { should validate_length_of(:title).is_at_most(200) }
  end

  describe '.search' do
    subject { described_class.search(query) }

    context 'when group without profile' do
      let_it_be(:group) { create(:group, title: 'wattitle', number: 'sonumber') }

      context 'with a matching title' do
        let(:query) { group.title }

        it { is_expected.to eq([group]) }
      end

      context 'with a partially matching title' do
        let(:query) { group.title[0..2] }

        it { is_expected.to eq([group]) }
      end

      context 'with a matching title regardless of the casting' do
        let(:query) { group.title.upcase }

        it { is_expected.to eq([group]) }
      end

      context 'with a matching number' do
        let(:query) { group.number }

        it { is_expected.to eq([group]) }
      end

      context 'with a partially matching number' do
        let(:query) { group.number[0..2] }

        it { is_expected.to eq([group]) }
      end

      context 'with a matching number regardless of the casting' do
        let(:query) { group.number.upcase }

        it { is_expected.to eq([group]) }
      end

      context 'with a blank query' do
        let(:query) { '' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
