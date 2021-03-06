# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  let(:config) do
    {
      'email_from' => 'seems@legit.email',
      'email_display_name' => 'wat',
      'email_reply_to' => 'no@way.email'
    }
  end

  before do
    allow_any_instance_of(described_class).to receive(:core_config).and_return(config)
  end

  describe '#default_sender_address' do
    subject { described_class.new.send(:default_sender_address) }

    it 'is expected to compose sender address' do
      expect(subject.display_name).to eq('wat')
      expect(subject.address).to eq('seems@legit.email')
    end
  end

  describe '#default_reply_to_address' do
    subject { described_class.new.send(:default_reply_to_address) }

    it 'is expected to compose reply address' do
      expect(subject.display_name).to eq('wat')
      expect(subject.address).to eq('no@way.email')
    end
  end
end
