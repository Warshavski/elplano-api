# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadProcessors::PromoteWorker do
  describe '#perform' do
    subject { described_class.new }

    let(:data) { double('data') }

    it 'is expected to trigger attacher promotion' do
      expect(Shrine::Attacher).to receive(:promote).with(data).once

      subject.perform(data)
    end
  end
end
