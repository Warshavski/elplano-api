# frozen_string_literal: true

require 'rails_helper'

RSpec.describe System::Health do
  describe '.call' do
    let_it_be(:test_data) { { test: { so: 'so', wat: 'wat' } } }

    let(:test_struct) do
      double('memory_struct', to_h: { so: 'so', wat: 'wat' })
    end

    let(:raw_data) { { test: test_struct } }

    before do
      allow_any_instance_of(described_class).to receive(:perform_checks).and_return(raw_data)
    end

    subject { described_class.call(type) }

    context 'when type is liveness' do
      let(:type) { 'liveness' }

      it { is_expected.to eq(test_data) }
    end

    context 'when type is readiness' do
      let(:type) { 'liveness' }

      it { is_expected.to eq(test_data) }
    end

    context 'when type is not valid' do
      let(:type) { 'wat' }

      it { is_expected.to eq({}) }
    end
  end
end
