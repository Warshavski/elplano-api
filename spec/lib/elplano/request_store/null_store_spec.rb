# frozen_string_literal: true

require 'rails_helper'

describe Elplano::RequestStore::NullStore do
  let_it_be(:null_store) { described_class.new }

  describe '#store' do
    it { expect(null_store.store).to eq({}) }
  end

  describe '#active?' do
    it { expect(null_store.active?).to be_falsey}
  end

  describe '#read' do
    it { expect(null_store.read('wat')).to be(nil) }
  end

  describe '#[]' do
    it { expect(null_store['foo']).to be nil }
  end

  describe '#write' do
    it { expect(null_store.write('key', 'value')).to eq('value') }
  end

  describe '#[]=' do
    it { expect(null_store['key'] = 'value').to eq('value') }
  end

  describe '#exist?' do
    it { expect(null_store.exist?('foo')).to be_falsey }
  end

  describe '#fetch' do
    it { expect(null_store.fetch('key') { 'block result' }).to eq('block result') }
  end

  describe '#delete' do
    context 'when a block is given' do
      it 'yields the key to the block' do
        expect { |b| null_store.delete('foo', &b) }.to yield_with_args('foo')
      end

      it 'returns the block result' do
        expect(null_store.delete('foo') { |_key| 'block result' }).to eq('block result')
      end
    end

    context 'when a block is not given' do
      it { expect(null_store.delete('foo')).to be(nil) }
    end
  end
end
