# frozen_string_literal: true

shared_context 'simple_check' do |metrics_prefix, _check_name, success_result|
  describe '#metrics' do
    subject { described_class.metrics }

    context 'when check is passing' do
      before do
        allow(described_class).to receive(:check).and_return success_result
      end

      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_success", value: 1)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_timeout", value: 0)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_latency_seconds", value: be >= 0)) }
    end

    context 'when check is misbehaving' do
      before do
        allow(described_class).to receive(:check).and_return 'error!'
      end

      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_success", value: 0)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_timeout", value: 0)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_latency_seconds", value: be >= 0)) }
    end

    context 'when check is timeout' do
      before do
        allow(described_class).to receive(:check).and_return Timeout::Error.new
      end

      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_success", value: 0)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_timeout", value: 1)) }
      it { is_expected.to include(have_attributes(name: "#{metrics_prefix}_latency_seconds", value: be >= 0)) }
    end
  end

  describe '#readiness' do
    subject { described_class.readiness }

    context 'when check is passing' do
      before do
        allow(described_class).to receive(:check).and_return success_result
      end

      it { is_expected.to have_attributes(success: true) }
    end

    context 'when check is misbehaving' do
      before do
        allow(described_class).to receive(:check).and_return 'error!'
      end

      it { is_expected.to have_attributes(success: false, message: "unexpected #{described_class.human_name} check result: error!") }
    end

    context 'when check is timeout' do
      before do
        allow(described_class).to receive(:check ).and_return Timeout::Error.new
      end

      it { is_expected.to have_attributes(success: false, message: "#{described_class.human_name} check timed out") }
    end
  end

  describe '#liveness' do
    subject { described_class.readiness }

    it { is_expected.to eq(Elplano::HealthChecks::Result.new(true)) }
  end
end
