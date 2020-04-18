# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcements::Cache do
  describe '.current', :use_clean_rails_memory_store_caching do
    subject { described_class.current }

    context 'when time match' do
      let_it_be(:first_announcement)  { create(:announcement) }
      let_it_be(:last_announcement)   { create(:announcement) }

      it { is_expected.to include(first_announcement) }

      it { is_expected.to contain_exactly(first_announcement, last_announcement) }

      it { expect { subject }.not_to change { Announcement.count } }
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

  describe '.flush' do
    subject { described_class.flush }

    it 'flushes the cache' do
      expect(Rails.cache).to receive(:delete).with(described_class::CACHE_KEY)

      subject
    end
  end
end
