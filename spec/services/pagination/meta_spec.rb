# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pagination::Meta do
  let(:request) do
    double(:request, base_url: 'https://example.com', path: '/api/v1/wat')
  end

  let(:resources) do
    double(:resources, total_pages: total_pages)
  end

  let(:filters) { {} }

  describe '#new' do
    subject { described_class.new(request, resources, filters) }

    let(:total_pages) { 2 }

    context 'when filters are not set' do
      it 'is expected to set default values' do
        instance = subject

        expect(instance.url).to eq('https://example.com/api/v1/wat')
        expect(instance.limit).to be(15)
        expect(instance.page).to be(1)
        expect(instance.total_pages).to be(2)
        expect(instance.filters).to eq({})
      end
    end

    context 'when filters are set' do
      let(:filters) { { page: 2, limit: 1, range: 'so' } }

      it { expect(subject.limit).to be(1) }

      it { expect(subject.page).to be(2) }

      it { expect(subject.filters).to eq(range: 'so') }
    end
  end

  describe '#execute' do
    subject { described_class.new(request, resources, filters).execute }

    context 'when total_pages equal 1' do
      let(:total_pages) { 1 }

      it { is_expected.to be_an(Hash) }

      it { expect(subject.dig(:meta, :total_pages)).to eq(1) }

      it { expect(subject.dig(:meta, :current_page)).to eq(1) }

      it { expect(subject.dig(:links).size).to eq(1) }

      it { expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?limit=15&page=1') }

      context 'when filters are defined' do
        let(:filters) { { page: 2, limit: 1, range: 'week' } }

        it { expect(subject.dig(:links).size).to eq(3) }

        it { expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?limit=1&page=2&range=week') }

        it { expect(subject.dig(:links, :first)).to eq('https://example.com/api/v1/wat?limit=1&page=1&range=week') }

        it { expect(subject.dig(:links, :prev)).to eq('https://example.com/api/v1/wat?limit=1&page=1&range=week') }

        it { expect(subject.dig(:meta, :current_page)).to eq(2) }
      end
    end

    context 'when total_pages more than 1' do
      let(:total_pages) { 3 }

      it { expect(subject.dig(:meta, :total_pages)).to eq(3) }

      it { expect(subject.dig(:meta, :current_page)).to eq(1) }

      it { expect(subject.dig(:links).size).to eq(3) }

      it { expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?limit=15&page=1') }

      it { expect(subject.dig(:links, :next)).to eq('https://example.com/api/v1/wat?limit=15&page=2') }

      it { expect(subject.dig(:links, :last)).to eq('https://example.com/api/v1/wat?limit=15&page=3') }

      context 'when filters are defined' do
        let(:filters) { { page: 2, limit: 1, range: 'week' } }

        it { expect(subject.dig(:links).size).to eq(5) }

        it { expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?limit=1&page=2&range=week') }

        it { expect(subject.dig(:links, :first)).to eq('https://example.com/api/v1/wat?limit=1&page=1&range=week') }

        it { expect(subject.dig(:links, :prev)).to eq('https://example.com/api/v1/wat?limit=1&page=1&range=week') }

        it { expect(subject.dig(:links, :next)).to eq('https://example.com/api/v1/wat?limit=1&page=3&range=week') }

        it { expect(subject.dig(:links, :last)).to eq('https://example.com/api/v1/wat?limit=1&page=3&range=week') }

        it { expect(subject.dig(:meta, :current_page)).to eq(2) }
      end
    end
  end
end
