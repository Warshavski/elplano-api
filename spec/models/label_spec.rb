# frozen_string_literal: true

require 'rails_helper'

describe Label, type: :model do
  describe 'associations' do
    it { should belong_to(:group) }

    it { should have_many(:label_links).dependent(:delete_all) }

    it { should have_many(:events).through(:label_links).source(:target) }
  end

  describe 'validations' do
    subject { build(:label) }

    it { is_expected.to be_valid }

    it { should validate_presence_of(:title) }

    it { should validate_length_of(:title).is_at_most(255) }

    it { should validate_uniqueness_of(:title).scoped_to(%i[group_id]).case_insensitive }

    it { should_not allow_value('EL,PLANO').for(:title) }

    it { should_not allow_value('').for(:title) }

    it { should_not allow_value('s' * 256).for(:title) }

    it { should allow_value('ELPLANO').for(:title) }

    it { should allow_value('elplano').for(:title) }

    it { should allow_value('E!PLAN0').for(:title) }

    it { should allow_value('EL&PLANO').for(:title) }

    it { should allow_value("lecturer's event").for(:title) }

    it { should allow_value('s' * 255).for(:title) }

    it_should_behave_like 'color validatable', :color, default_value: true
  end

  context 'callbacks' do
    describe 'before_validation' do
      let_it_be(:subject) { create(:label, title: ' lOoK ', color: ' ') }

      it 'is expected to normalize title and set default color' do
        expect(subject.title).to eq('look')
        expect(subject.color).to eq('#428BCA')
      end
    end
  end

  describe '.search' do
    subject { described_class.search(query) }

    context 'when label without profile' do
      let_it_be(:label) { create(:label, title: 'wattitle', description: 'sodescription') }

      context 'with a matching title' do
        let(:query) { label.title }

        it { is_expected.to eq([label]) }
      end

      context 'with a partially matching title' do
        let(:query) { label.title[0..2] }

        it { is_expected.to eq([label]) }
      end

      context 'with a matching title regardless of the casting' do
        let(:query) { label.title.upcase }

        it { is_expected.to eq([label]) }
      end

      context 'with a matching description' do
        let(:query) { label.description }

        it { is_expected.to eq([label]) }
      end

      context 'with a partially matching description' do
        let(:query) { label.description[0..2] }

        it { is_expected.to eq([label]) }
      end

      context 'with a matching description regardless of the casting' do
        let(:query) { label.description.upcase }

        it { is_expected.to eq([label]) }
      end

      context 'with a blank query' do
        let(:query) { '' }

        it { is_expected.to eq([]) }
      end
    end
  end

  describe '#text_color' do
    let_it_be(:label) { build(:label) }

    it 'generates proper text color based on color' do
      label.color = '#222E2E'
      expect(label.text_color).to eq('#FFFFFF')

      label.color = '#EEEEEE'
      expect(label.text_color).to eq('#333333')
    end
  end
end
