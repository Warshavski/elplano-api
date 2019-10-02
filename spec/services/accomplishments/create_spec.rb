# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accomplishments::Create do
  describe '.call' do
    subject { described_class.call(student, assignment, params) }

    let_it_be(:student) { create(:student, :group_supervisor) }
    let_it_be(:course)  { create(:course, group: student.group) }

    let_it_be(:assignment) { create(:assignment, author: student, course: course) }

    let_it_be(:file)      { fixture_file_upload('spec/fixtures/files/pdf_sample.pdf') }
    let_it_be(:metadata)  { AttachmentUploader.new(:cache).upload(file) }

    let_it_be(:params) { { attachments: [metadata.to_json] } }

    context 'when accomplishment is not exists' do
      it { is_expected.to be_an(Accomplishment) }

      it { expect { subject }.to change(Accomplishment, :count).by(1) }

      it { expect { subject }.to change(Attachment, :count).by(1) }
    end

    context 'when attachments are not presented' do
      let_it_be(:params) { { attachments: [] } }

      it { expect { subject }.to not_change(Attachment, :count) }
    end

    context 'when accomplishment is already exists' do
      let_it_be(:accomplishment) do
        create(:accomplishment, student: student, assignment: assignment)
      end

      it { is_expected.to be(nil) }

      it { expect { subject }.to not_change(Accomplishment, :count) }
    end
  end
end
