# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pagination::Meta do
  let(:request) do
    double(:request, base_url: 'https://example.com', path: '/api/v1/wat')
  end

  let(:resources) do
    double(:resources, total_pages: total_pages)
  end

  let(:filter) { {} }

  describe '#new' do
    subject { described_class.new(request, resources, filter) }

    let(:total_pages) { 2 }

    context 'when filter are not set' do
      it 'is expected to set default values' do
        instance = subject

        expect(instance.url).to eq('https://example.com/api/v1/wat')
        expect(instance.size).to be(15)
        expect(instance.number).to be(1)
        expect(instance.total_pages).to be(2)
        expect(instance.filter).to eq({})
      end
    end

    context 'when filter are set' do
      let(:filter) do
        {
          page: { number: 2, size: 1 },
          filter: { range: 'so' }
        }
      end

      it 'is expected to set proper attributes' do
        expect(subject.size).to be(1)
        expect(subject.number).to be(2)
        expect(subject.filter).to eq(filter: { range: 'so' })
      end
    end
  end

  describe '#execute' do
    subject { described_class.new(request, resources, filter).execute }

    context 'when total_pages equal 1' do
      let(:total_pages) { 1 }

      it 'is expected to set proper meta information' do
        is_expected.to be_an(Hash)

        expect(subject.dig(:meta, :total_pages)).to eq(1)
        expect(subject.dig(:meta, :current_page)).to eq(1)
        expect(subject.dig(:links).size).to eq(1)
        expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?page%5Bnumber%5D=1&page%5Bsize%5D=15')
      end

      context 'when filter are defined' do
        let(:filter) do
          {
            page: { number: 2, size: 1 },
            filter: { range: 'week' }
          }
        end

        it 'is expected to set proper meta information' do
          expect(subject.dig(:links).size).to eq(3)
          expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=2&page%5Bsize%5D=1')
          expect(subject.dig(:links, :first)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=1&page%5Bsize%5D=1')
          expect(subject.dig(:links, :prev)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=1&page%5Bsize%5D=1')
          expect(subject.dig(:meta, :current_page)).to eq(2)
        end
      end
    end

    context 'when total_pages more than 1' do
      let(:total_pages) { 3 }

      it 'is expected to set proper meta information' do
        expect(subject.dig(:meta, :total_pages)).to eq(3)
        expect(subject.dig(:meta, :current_page)).to eq(1)
        expect(subject.dig(:links).size).to eq(3)
        expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?page%5Bnumber%5D=1&page%5Bsize%5D=15')
        expect(subject.dig(:links, :next)).to eq('https://example.com/api/v1/wat?page%5Bnumber%5D=2&page%5Bsize%5D=15')
        expect(subject.dig(:links, :last)).to eq('https://example.com/api/v1/wat?page%5Bnumber%5D=3&page%5Bsize%5D=15')
      end

      context 'when filter are defined' do
        let(:filter) do
          {
            page: { number: 2, size: 1 },
            filter: { range: 'week' }
          }
        end

        it 'is expected to set proper meta information' do
          expect(subject.dig(:links).size).to eq(5)
          expect(subject.dig(:links, :self)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=2&page%5Bsize%5D=1')
          expect(subject.dig(:links, :first)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=1&page%5Bsize%5D=1')
          expect(subject.dig(:links, :prev)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=1&page%5Bsize%5D=1')
          expect(subject.dig(:links, :next)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=3&page%5Bsize%5D=1')
          expect(subject.dig(:links, :last)).to eq('https://example.com/api/v1/wat?filter%5Brange%5D=week&page%5Bnumber%5D=3&page%5Bsize%5D=1')
          expect(subject.dig(:meta, :current_page)).to eq(2)
        end
      end
    end
  end
end
