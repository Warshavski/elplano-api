# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('Student') }

    it { should belong_to(:course).optional }

    it { should belong_to(:eventable) }

    it { should have_many(:label_links).dependent(:delete_all) }

    it { should have_many(:labels).through(:label_links) }
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

    it_should_behave_like 'color validatable', :background_color

    it_should_behave_like 'color validatable', :foreground_color
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

  describe '.filter_by' do
    let_it_be(:event) { double }

    it 'returns none with not existed filter name' do
      expect(described_class.filter_by('wat')).to eq([])
    end

    it 'filters by default group and personal events' do
      expect(described_class).to receive(:personal_or_group).and_return([event])

      expect(described_class.filter_by(nil)).to eq([event])
    end

    it 'filters by group events' do
      expect(described_class).to receive(:groups).and_return([event])

      expect(described_class.filter_by('group')).to eq([event])
    end

    it 'filters by personal events' do
      expect(described_class).to receive(:personal).and_return([event])

      expect(described_class.filter_by('personal')).to eq([event])
    end
  end

  context 'callbacks' do
    describe 'before_validation' do
      before(:each) { model.valid? }

      context 'when eventable type is nil' do
        let_it_be(:model) { described_class.new(eventable_type: nil) }

        it 'leaves eventable type nil' do
          expect(model.eventable_type).to be(nil)
        end
      end

      context 'when eventable type is a string in downcase' do
        let_it_be(:model) { described_class.new(eventable_type: 'student') }

        it 'makes eventable type classy like string' do
          expect(model.eventable_type).to eq('Student')
        end
      end

      context 'when eventable type is a string in uppercase' do
        let_it_be(:model) { described_class.new(eventable_type: 'STUDENT') }

        it 'keeps eventable type as an uppercase string' do
          expect(model.eventable_type).to eq('STUDENT')
        end
      end

      context 'when eventable type is a classy like string' do
        let_it_be(:model) { described_class.new(eventable_type: 'Student') }

        it 'keeps eventable type as a classy like string' do
          expect(model.eventable_type).to eq('Student')
        end
      end
    end
  end
end
