# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('Student') }

    it { should belong_to(:course).optional }

    it { should belong_to(:eventable) }
  end

  describe 'validations' do
    subject { build_stubbed(:event) }

    it { should validate_presence_of(:title) }

    it { should validate_length_of(:title).is_at_least(3).is_at_most(250) }

    it { should validate_presence_of(:creator) }

    it { should validate_presence_of(:start_at) }

    it { should validate_presence_of(:timezone) }

    it do
      should define_enum_for(:status)
               .with_values(confirmed: 'confirmed', tentative: 'tentative', cancelled: 'cancelled')
               .backed_by_column_of_type(:string)
    end
  end

  context 'scopes' do
    context 'eventable type' do
      let_it_be(:student) { create(:student, :group_supervisor) }

      let_it_be(:personal_event) do
        create(:event, creator: student, eventable: student)
      end

      let_it_be(:group_event) do
        create(:event, creator: student, eventable: student.group)
      end

      describe '.personal' do
        subject { described_class.personal }

        it { is_expected.to eq([personal_event]) }
      end

      describe '.groups' do
        subject { described_class.groups }

        it { is_expected.to eq([group_event]) }
      end

      describe '.personal_or_group' do
        subject { described_class.personal_or_group }

        it { is_expected.to match_array([personal_event, group_event]) }
      end
    end
  end

  describe '.filter' do
    let_it_be(:event) { double }

    it 'returns none with not existed filter name' do
      expect(described_class.filter('wat')).to eq([])
    end

    it 'filters by default group and personal events' do
      expect(described_class).to receive(:personal_or_group).and_return([event])

      expect(described_class.filter(nil)).to eq([event])
    end

    it 'filters by group events' do
      expect(described_class).to receive(:groups).and_return([event])

      expect(described_class.filter('group')).to eq([event])
    end

    it 'filters by personal events' do
      expect(described_class).to receive(:personal).and_return([event])

      expect(described_class.filter('personal')).to eq([event])
    end
  end
end
