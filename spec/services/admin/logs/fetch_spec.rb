# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Logs::Fetch do
  describe '.call' do
    subject { described_class.call }

    context 'when log file exists' do
      before do
        allow(Elplano::Loggers::AppLogger).to receive(:file_name).and_return('wat.log')
        allow(Elplano::Loggers::AppLogger).to receive(:read_latest).and_return(%w[wat so])
      end

      it { is_expected.to eq([{ file_name: 'wat.log', logs: %w[wat so] }]) }
    end

    context 'when log file not exists' do
      before do
        allow(Elplano::Loggers::AppLogger).to receive(:file_name).and_return(nil)
        allow(Elplano::Loggers::AppLogger).to receive(:read_latest).and_return([])
      end

      it { is_expected.to eq([{ file_name: nil, logs: [] }]) }
    end
  end
end
