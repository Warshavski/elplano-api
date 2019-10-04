# frozen_string_literal: true

require 'rails_helper'

describe Announcement, type: :model do
  context 'validations' do
    subject { build(:announcement) }

    it { is_expected.to be_valid }

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

    it { should validate_presence_of(:message) }

    it { should validate_presence_of(:start_at) }

    it { should validate_presence_of(:end_at) }
  end

  describe '.current', :use_clean_rails_memory_store_caching do
    subject { described_class.current }

    context 'when time match' do
      let_it_be(:first_announcement)  { create(:announcement) }
      let_it_be(:last_announcement)   { create(:announcement) }

      it { is_expected.to include(first_announcement) }

      it { is_expected.to contain_exactly(first_announcement, last_announcement) }

      it { expect { subject }.not_to change { described_class.count } }
    end

    context 'when time is not come' do
      let_it_be(:announcement) { create(:announcement, :upcoming) }

      it { is_expected.to be_empty }

      it 'does not clear the cache' do
        expect(Rails.cache).not_to receive(:delete).with(described_class::CACHE_KEY)
        expect(subject.size).to eq(0)
      end
    end

    context 'when time has passed' do
      let_it_be(:announcement) { create(:announcement, :expired) }

      it { is_expected.to be_empty }
    end
  end

  context 'timeline checks' do
    let_it_be(:default)   { build(:announcement) }
    let_it_be(:upcoming)  { build(:announcement, :upcoming) }
    let_it_be(:expired)   { build(:announcement, :expired) }

    describe '#active?' do
      context 'when started and not ended' do
        it { expect(default).to be_active }
      end

      context 'when ended' do
        it { expect(expired).not_to be_active }
      end

      context 'when not started' do
        it { expect(upcoming).not_to be_active }
      end
    end

    describe '#started?' do
      context 'when starts_at has passed' do
        it { Timecop.travel(3.days.from_now) { expect(default).to be_started } }
      end

      context 'when start_at is in the upcoming' do
        it { Timecop.travel(3.days.ago) { expect(default).not_to be_started } }
      end
    end

    describe '#ended?' do
      context 'when ends_at has passed' do
        it { Timecop.travel(3.days.from_now) { expect(default).to be_ended } }
      end

      context 'when ends_at is in the upcoming' do
        it { Timecop.travel(3.days.ago) { expect(default).not_to be_ended } }
      end
    end
  end

  describe '#flush_cache' do
    it 'flushes the cache' do
      message = create(:announcement)

      expect(Rails.cache).to receive(:delete).with(described_class::CACHE_KEY)

      message.flush_cache
    end
  end
end
