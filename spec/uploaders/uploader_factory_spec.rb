require 'rails_helper'

RSpec.describe UploaderFactory do
  describe '.fabricate' do
    subject { described_class.fabricate(uploader_type, storage_type) }

    let(:uploader_type) { :avatar }
    let(:storage_type)  { :cache }

    context 'invalid input' do
      context 'nil uploader type' do
        let(:uploader_type) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'nil storage type' do
        let(:storage_type) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'non existed uploader' do
        let(:uploader_type) { :wat }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end
    end

    context 'valid input' do
      it { expect(subject).to be_a(AvatarUploader) }
    end
  end
end
