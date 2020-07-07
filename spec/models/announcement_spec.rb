# frozen_string_literal: true

require 'rails_helper'

describe Announcement, type: :model do
  describe 'validations' do
    subject { build(:announcement) }

    it { is_expected.to be_valid }

    it { should validate_presence_of(:message) }

    it { should validate_presence_of(:start_at) }

    it { should validate_presence_of(:end_at) }

    it_should_behave_like 'color validatable', :background_color

    it_should_behave_like 'color validatable', :foreground_color
  end

  describe '.current_and_upcoming' do
    subject { described_class.current_and_upcoming }

    let_it_be(:current) { create(:announcement, :current) }

    let_it_be(:first_upcoming)  { create(:announcement, :upcoming) }
    let_it_be(:second_upcoming) { create(:announcement, :upcoming) }

    let_it_be(:expired) { create(:announcement, :expired) }

    it 'is expected to return current and upcoming alerts' do
      is_expected.to eq([current, first_upcoming, second_upcoming])
    end
  end

  describe '#now?' do
    subject { build(:announcement, type).now? }

    context 'when announcement is current' do
      let(:type) { :current }

      it { is_expected.to be true }
    end

    context 'when announcement is upcoming' do
      let(:type) { :upcoming }

      it { is_expected.to be false }
    end

    context 'when announcement is expired' do
      let(:type) { :expired }

      it { is_expected.to be false }
    end
  end

  describe '#upcoming?' do
    subject { build(:announcement, type).upcoming? }

    context 'when announcement is current' do
      let(:type) { :current }

      it { is_expected.to be false }
    end

    context 'when announcement is upcoming' do
      let(:type) { :upcoming }

      it { is_expected.to be true }
    end

    context 'when announcement is expired' do
      let(:type) { :expired }

      it { is_expected.to be false }
    end
  end

  describe '#now_or_upcoming?' do
    subject { build(:announcement, type).now_or_upcoming? }

    context 'when announcement is current' do
      let(:type) { :current }

      it { is_expected.to be true }
    end

    context 'when announcement is upcoming' do
      let(:type) { :upcoming }

      it { is_expected.to be true }
    end

    context 'when announcement is expired' do
      let(:type) { :expired }

      it { is_expected.to be false }
    end
  end
end
