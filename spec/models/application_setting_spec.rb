# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationSetting do
  describe '#host' do
    subject { described_class.host(url) }

    context 'url with http' do
      let(:url) { 'http://wat.host' }

      it { expect(subject).to eq('wat.host') }
    end

    context 'url with https' do
      let(:url) { 'https://wat.host' }

      it { expect(subject).to eq('wat.host') }
    end

    context 'just host' do
      let(:url) { 'wat.host' }

      it { expect(subject).to eq('wat.host') }
    end

    context 'just host with www' do
      let(:url) { 'wat.host' }

      it { expect(subject).to eq('wat.host') }
    end
  end

  describe '#host_without_www' do
    subject { described_class.host_without_www(url) }

    context 'url with http' do
      let(:url) { 'http://www.wat.host' }

      it { expect(subject).to eq('wat.host') }
    end

    context 'url with https' do
      let(:url) { 'https://www.wat.host' }

      it { expect(subject).to eq('wat.host') }
    end

    context 'url with just host' do
      let(:url) { 'www.wat.host' }

      it { expect(subject).to eq('wat.host') }
    end
  end

  describe '#build_base_elplano_url' do
    subject { described_class.build_base_elplano_url }

    it { expect(subject).to eq('http://localhost') }
  end
end
