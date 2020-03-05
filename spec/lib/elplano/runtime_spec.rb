# frozen_string_literal: true

require 'rails_helper'

describe Elplano::Runtime do
  before do
    # allow(described_class).to receive(:process_name).and_return('ruby')
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
  end

  context 'sidekiq' do
    let(:sidekiq_type) { double('::Sidekiq') }

    before do
      stub_const('::Sidekiq', sidekiq_type)
      allow(sidekiq_type).to receive(:server?).and_return(true)
      allow(sidekiq_type).to receive(:options).and_return(concurrency: 2)
    end

    it_behaves_like 'valid runtime', :sidekiq, 3
  end
end
