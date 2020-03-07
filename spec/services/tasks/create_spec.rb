# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::Create do
  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:event)   { create(:event, eventable: student.group, creator: student) }

  let_it_be(:file)      { fixture_file_upload('spec/fixtures/files/pdf_sample.pdf') }
  let_it_be(:metadata)  { AttachmentUploader.new(:cache).upload(file) }

  let(:valid_params) { { title: 'wat_title', event_id: event.id, attachments: [metadata.to_json] } }

  describe '.call' do
    subject { described_class.call(student, params) }

    let(:params) { valid_params }

    it { expect { subject }.to change(Task, :count).by(1) }

    it { expect { subject }.to change(Attachment, :count).by(1) }

    it { is_expected.to be_an(Task) }

    context 'when event_id is not provided' do
      let(:params) { { title: 'wat_title' } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when event in not existed' do
      let(:params) { { title: 'wat_title', event_id: 0 } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when title is not provided' do
      let(:params) { { event_id: event.id } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when title is blank' do
      let(:params) { { title: '', event_id: event.id } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'when attachments data are not presented' do
      let(:params) { valid_params.without(:attachments) }

      it { expect { subject }.to not_change(Attachment, :count) }
    end

    context 'when classmates are provided' do
      let_it_be(:classmates) { create_list(:student, 2, group: student.group) }

      let(:params) { valid_params.merge(student_ids: classmates.pluck(:id)) }

      it { expect { subject }.to change(Task, :count).by(1) }

      it { expect { subject }.to change(Assignment, :count).by(classmates.size) }
    end

    context 'when random students are provided' do
      let_it_be(:students) { create_list(:student, 2) }

      let(:params) { valid_params.merge(student_ids: students.pluck(:id)) }

      it { expect { subject }.to change(Task, :count).by(1) }

      it { expect { subject }.not_to change(Assignment, :count) }
    end

    context 'when classmates are not provided' do
      let(:params) { valid_params.merge(student_ids: []) }

      it { expect { subject }.to change(Task, :count).by(1) }

      it { expect { subject }.not_to change(Assignment, :count) }
    end

    context 'when author is not a group owner' do
      subject { described_class.call(regular_member, params) }

      let_it_be(:regular_member) { create(:student, group: student.group) }
      let_it_be(:event) { create(:event, eventable: regular_member, creator: regular_member) }

      let(:params) do
        {
          title: 'wat_title',
          event_id: event.id,
          attachments: [metadata.to_json],
          student_ids: classmates_ids
        }
      end

      context 'when task is self assigned' do
        let(:classmates_ids) { [regular_member] }

        it { expect { subject }.to change(Task, :count).by(1) }

        it { expect { subject }.to change(Assignment, :count).by(classmates_ids.size) }
      end

      context 'when task is not self assigned' do
        let(:classmates_ids) { [student.id] }

        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end
end
