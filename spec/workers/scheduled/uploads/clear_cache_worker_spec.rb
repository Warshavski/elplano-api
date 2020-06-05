# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scheduled::Uploads::ClearCacheWorker do
  describe '#perform' do
    subject { described_class.new }

    it 'is expected to trigger cache clear service' do
      expect(::Uploads::ClearCache).to receive(:call).once

      subject.perform
    end
  end
end
