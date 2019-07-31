require 'rails_helper'

RSpec.describe Uploads::Cache do
  describe '.call' do
    subject { described_class.call(params) }

    let(:params)  { { file: file, type: type } }
    let(:file)    { fixture_file_upload('spec/fixtures/files/dk.png') }
    let(:type)    { :avatar }

    context 'valid invite' do
      it { expect(subject).to be_an(Shrine::UploadedFile) }

      it 'returns file with expected metadata' do
        actual_metadata = subject.data['metadata']
        expected_metadata = {
          'filename' => 'dk.png',
          'size' => 1_062,
          'mime_type' => 'image/png'
        }

        expect(actual_metadata).to eq(expected_metadata)
      end
    end

    context 'invalid request' do
      context 'without file param' do
        let(:file) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'without type param' do
        let(:type) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'without not existed uploader type' do
        let(:type) { :wat }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end
    end
  end
end
