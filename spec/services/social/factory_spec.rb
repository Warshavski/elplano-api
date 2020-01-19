require 'rails_helper'

RSpec.describe Social::Factory do
  describe '.call' do
    subject { described_class.call(provider_type) }

    context 'when input is not valid' do
      context 'when provider type is nil' do
        let(:provider_type) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'when provider is not exist' do
        let(:provider_type) { :wat }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end
    end

    context 'when input is valid' do
      let(:provider_type) { :google }

      it { is_expected.to eq(Social::Google::Auth) }
    end
  end
end
