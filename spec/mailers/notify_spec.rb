# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notify, type: :mailer do
  describe '#subject' do
    let(:suffix) do
      { 'email_subject_suffix' => nil }
    end

    let(:extra) { nil }

    before do
      allow_any_instance_of(described_class).to receive(:core_config).and_return(suffix)
    end

    subject { described_class.new.send(:subject, extra) }

    context 'default' do
      it { expect(subject).to eq('') }
    end

    context 'with single extra' do
      let(:extra) { 'wat' }

      it { expect(subject).to eq('wat') }
    end

    context 'with multiple extra' do
      let(:extra) { %w[wat so] }

      it { expect(subject).to eq('wat | so') }
    end

    context 'with suffix' do
      let(:suffix) do
        { 'email_subject_suffix' => 'suffix' }
      end

      it { expect(subject).to eq(' | suffix') }
    end

    context 'with suffix and extra' do
      let(:suffix) do
        { 'email_subject_suffix' => 'suffix' }
      end

      let(:extra) { %w[wat so] }

      it { expect(subject).to eq('wat | so | suffix') }
    end
  end

  describe '#sender' do
    before do
      allow_any_instance_of(described_class).to receive(:default_sender_address).and_return(Mail::Address.new('wat'))
    end

    let(:user) { create(:user, username: 'so') }

    subject { described_class.new.send(:sender, user.id) }

    it { expect(subject).to eq("so <wat>") }
  end
end
