# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachments::Create do
  describe '.call' do
    let_it_be(:author)  { create(:user) }
    let_it_be(:model)   { create(:assignment) }

    let_it_be(:file)      { fixture_file_upload('spec/fixtures/files/pdf_sample.pdf') }
    let_it_be(:metadata)  { AttachmentUploader.new(:cache).upload(file) }

    subject { described_class.call(author, model, attachments_data) }

    context 'when attachments data is not blank' do
      let_it_be(:attachments_data) { [metadata.to_json] }

      it { expect { subject }.to change(Attachment, :count).by(1) }

      it { is_expected.to be_a(Array) }
    end

    context 'when attachments data is blank' do
      let_it_be(:attachments_data) { [] }

      it { expect { subject }.to not_change(Attachment, :count) }

      it { is_expected.to be(nil) }
    end
  end
end
