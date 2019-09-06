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

    it { should allow_value('#1f1f1F').for(:background_color) }

    it { should allow_value('#AFAFAF').for(:background_color) }

    it { should allow_value('#222fff').for(:background_color) }

    it { should allow_value('#F00').for(:background_color) }

    it { should allow_value('#1AFFa1').for(:background_color) }

    it { should allow_value('#000000').for(:background_color) }

    it { should allow_value('#ea00FF').for(:background_color) }

    it { should allow_value('#eb0').for(:background_color) }

    it { should allow_value(nil).for(:background_color) }

    it { should_not allow_value('123456').for(:background_color) }

    it { should_not allow_value('#afafah').for(:background_color) }

    it { should_not allow_value('#123abce').for(:background_color) }

    it { should_not allow_value('aFaE3f').for(:background_color) }

    it { should_not allow_value('F00').for(:background_color) }

    it { should_not allow_value('#afaf').for(:background_color) }

    it { should_not allow_value('#afaf').for(:background_color) }

    it { should_not allow_value('#F0h').for(:background_color) }

    it { should_not allow_value('').for(:background_color) }

    it { should_not allow_value(0).for(:background_color) }

    it { should_not allow_value('#1f1f1F1f1f1F').for(:background_color) }

    it { should allow_value('#1f1f1F').for(:foreground_color) }

    it { should allow_value('#AFAFAF').for(:foreground_color) }

    it { should allow_value('#222fff').for(:foreground_color) }

    it { should allow_value('#F00').for(:foreground_color) }

    it { should allow_value('#1AFFa1').for(:foreground_color) }

    it { should allow_value('#000000').for(:foreground_color) }

    it { should allow_value('#ea00FF').for(:foreground_color) }

    it { should allow_value('#eb0').for(:foreground_color) }

    it { should allow_value(nil).for(:foreground_color) }

    it { should_not allow_value('123456').for(:foreground_color) }

    it { should_not allow_value('#afafah').for(:foreground_color) }

    it { should_not allow_value('#123abce').for(:foreground_color) }

    it { should_not allow_value('aFaE3f').for(:foreground_color) }

    it { should_not allow_value('F00').for(:foreground_color) }

    it { should_not allow_value('#afaf').for(:foreground_color) }

    it { should_not allow_value('#afaf').for(:foreground_color) }

    it { should_not allow_value('#F0h').for(:foreground_color) }

    it { should_not allow_value('').for(:foreground_color) }

    it { should_not allow_value(0).for(:foreground_color) }

    it { should_not allow_value('#1f1f1F1f1f1F').for(:foreground_color) }
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
