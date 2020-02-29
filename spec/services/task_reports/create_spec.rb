# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskReports::Create do
  describe '.call' do
    subject { described_class.call(student, assignment, params) }

    let_it_be(:student) { create(:student, :group_supervisor) }
    let_it_be(:course)  { create(:course, group: student.group) }
    let_it_be(:event)   { create(:event, eventable: student.group, )}

    let_it_be(:task)        { create(:task, author: student, event: event) }
    let_it_be(:assignment)  { create(:assignment, student: student, task: task) }

    let_it_be(:file)      { fixture_file_upload('spec/fixtures/files/pdf_sample.pdf') }
    let_it_be(:metadata)  { AttachmentUploader.new(:cache).upload(file) }

    let_it_be(:params) do
      {
        attachments: [metadata.to_json],
        accomplished: true,
        report: Faker::Lorem.paragraph(sentence_count: 6),
        extra_links: (1..2).flat_map { Faker::Internet.url }
      }
    end

    it 'is expected to update assignment with report' do
      is_expected.to be_an(Assignment)

      assignment.reload

      expect(assignment.report).to eq(params[:report])
      expect(assignment.accomplished).to eq(params[:accomplished])
      expect(assignment.extra_links).to eq(params[:extra_links])
    end

    it { expect { subject }.to change(Attachment, :count).by(1) }

    it { expect { subject }.to change(ActivityEvent, :count).by(1) }

    context 'when attachments are not presented' do
      let_it_be(:params) { { attachments: [] } }

      it { expect { subject }.to not_change(Attachment, :count) }
    end
  end
end
