# frozen_string_literal: true

require 'rails_helper'

describe Elplano::RequestStore::SafeStore do
  describe '.store' do
    subject { described_class.store }

    context 'when RequestStore is active', :request_store do
      it { is_expected.to eq(RequestStore) }
    end

    context 'when RequestStore is NOT active' do
      it { is_expected.to be_a(Elplano::RequestStore::NullStore) }
    end
  end

  describe '.begin!' do
    subject { described_class.begin! }

    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:begin!)

        subject
      end
    end

    context 'when RequestStore is NOT active' do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:begin!)

        subject
      end
    end
  end

  describe '.clear!' do
    subject { described_class.clear! }

    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:clear!).twice.and_call_original

        subject
      end
    end

    context 'when RequestStore is NOT active' do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:clear!).and_call_original

        subject
      end
    end
  end

  describe '.end!' do
    subject { described_class.end! }

    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:end!).twice.and_call_original

        subject
      end
    end

    context 'when RequestStore is NOT active' do
      it 'uses RequestStore' do
        expect(RequestStore).to receive(:end!).and_call_original

        subject
      end
    end
  end

  describe '.write' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { described_class.write('foo', true) }.to change { described_class.read('foo') }.from(nil).to(true)
      end

      it 'does not pass the options hash to the underlying store implementation' do
        expect(described_class.store).to receive(:write).with('foo', true)

        described_class.write('foo', true, expires_in: 15.seconds)
      end
    end

    context 'when RequestStore is NOT active' do
      it 'does not use RequestStore' do
        expect { described_class.write('foo', true) }.not_to change { described_class.read('foo') }.from(nil)
      end

      it 'does not pass the options hash to the underlying store implementation' do
        expect(described_class.store).to receive(:write).with('foo', true)

        described_class.write('foo', true, expires_in: 15.seconds)
      end
    end
  end

  describe '.[]=' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { described_class['foo'] = true }.to change { described_class.read('foo') }.from(nil).to(true)
      end
    end

    context 'when RequestStore is NOT active' do
      it 'does not use RequestStore' do
        expect { described_class['foo'] = true }.not_to change { described_class.read('foo') }.from(nil)
      end
    end
  end

  describe '.read' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { RequestStore.write('foo', true) }.to change { described_class.read('foo') }.from(nil).to(true)
      end
    end

    context 'when RequestStore is NOT active' do
      it 'does not use RequestStore' do
        expect { RequestStore.write('foo', true) }.not_to change { described_class.read('foo') }.from(nil)

        RequestStore.clear! # Clean up
      end
    end
  end

  describe '.[]' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { RequestStore.write('foo', true) }.to change { described_class['foo'] }.from(nil).to(true)
      end
    end

    context 'when RequestStore is NOT active' do
      it 'does not use RequestStore' do
        expect { RequestStore.write('foo', true) }.not_to change { described_class['foo'] }.from(nil)

        RequestStore.clear! # Clean up
      end
    end
  end

  describe '.exist?' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { RequestStore.write('foo', 'not nil') }.to change { described_class.exist?('foo') }.from(false).to(true)
      end
    end

    context 'when RequestStore is NOT active' do
      it 'does not use RequestStore' do
        expect { RequestStore.write('foo', 'not nil') }.not_to change { described_class.exist?('foo') }.from(false)

        RequestStore.clear! # Clean up
      end
    end
  end

  describe '.fetch' do
    subject { described_class.fetch('foo') { 'block result' } }

    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        expect { subject }.to change { described_class.read('foo') }.from(nil).to('block result')
      end
    end

    context 'when RequestStore is NOT active' do
      before  { RequestStore.clear! }
      after   { RequestStore.clear! }

      it 'does not use RequestStore' do
        expect { subject }.not_to change { described_class.read('foo') }.from(nil)
      end
    end
  end

  describe '.delete' do
    context 'when RequestStore is active', :request_store do
      it 'uses RequestStore' do
        described_class.write('foo', true)

        expect { described_class.delete('foo') }.to change { described_class.read('foo') }.from(true).to(nil)
      end

      context 'when given a block and the key exists' do
        it 'does not execute the block' do
          described_class.write('foo', true)

          expect { |b| described_class.delete('foo', &b) }.not_to yield_control
        end
      end

      context 'when given a block and the key does not exist' do
        subject { described_class.delete('foo') { |key| "#{key} block result" } }

        it { is_expected.to eq('foo block result') }
      end
    end

    context 'when RequestStore is NOT active' do
      subject { described_class.delete('foo') }

      before  { RequestStore.write('foo', true) }
      after   { RequestStore.clear! }

      it 'does not use RequestStore' do
        expect { subject }.not_to change { RequestStore.read('foo') }.from(true)
      end

      context 'when given a block' do
        subject { described_class.delete('foo') { |key| "#{key} block result" } }

        it { is_expected.to eq('foo block result') }
      end
    end
  end
end
