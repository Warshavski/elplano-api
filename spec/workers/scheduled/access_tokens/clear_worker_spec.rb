# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scheduled::AccessTokens::ClearWorker do
  describe '#perform' do
    subject { described_class.new }

    before do
      allow(ENV).to receive(:[]).with('DOORKEEPER_DAYS_TRIM_THRESHOLD').and_return(10)
    end

    it 'is expected to trigger tokens clear service' do
      expect(::AccessTokens::Clear).to receive(:call).with(10).once

      subject.perform
    end
  end
end
