# frozen_string_literal: true

require 'rails_helper'

describe Announcement, type: :model do
  context 'validations' do
    subject { build(:announcement) }

    it { is_expected.to be_valid }

    it { should validate_presence_of(:message) }

    it { should validate_presence_of(:start_at) }

    it { should validate_presence_of(:end_at) }

    it_should_behave_like 'color validatable', :background_color

    it_should_behave_like 'color validatable', :foreground_color
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
        it { travel_to(3.days.from_now) { expect(default).to be_started } }
      end

      context 'when start_at is in the upcoming' do
        it { travel_to(3.days.ago) { expect(default).not_to be_started } }
      end
    end

    describe '#ended?' do
      context 'when ends_at has passed' do
        it { travel_to(3.days.from_now) { expect(default).to be_ended } }
      end

      context 'when ends_at is in the upcoming' do
        it { travel_to(3.days.ago) { expect(default).not_to be_ended } }
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
