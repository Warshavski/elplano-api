# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadProcessors::DeleteWorker do
  describe '#perform' do
    subject { described_class.new }

    let(:data) { double('data') }

    it 'is expected to trigger attacher delete' do
      expect(Shrine::Attacher).to receive(:delete).with(data).once

      subject.perform(data)
    end
  end
end
