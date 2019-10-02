# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentUploader do
  let(:attachment)    { build(:attachment, attachment: uploaded_file.to_json) }
  let(:uploaded_file) { described_class.new(:cache).upload(file) }
  let(:file)          { File.open(file_fixture('pdf_sample.pdf')) }

  describe 'validations' do
    subject { attachment.valid? }

    it 'passes upload with no errors' do
      subject

      expect(attachment.errors).to be_empty
    end

    context 'when extension is not correct' do
      let(:file) { File.open(file_fixture('video_sample.mp4')) }

      it 'fals with type validation error' do
        subject

        expect(attachment.errors[:attachment].to_s).to include("type must be one of")
      end
    end

    context 'when file size is not correct' do
      before do
        stub_const('AttachmentUploader::MAX_SIZE', 0)
      end

      it 'fals with size validation error' do
        subject

        expect(attachment.errors[:attachment].to_s).to include('is too large')
      end
    end
  end
end
