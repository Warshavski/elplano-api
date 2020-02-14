# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invites::Claim do
  describe '.call' do
    subject { described_class.call(student, token) }

    context 'valid invite' do
      let(:student) { create(:student) }
      let(:invite)  { create(:invite, :rnd_group, email: student.user.email) }
      let(:token)   { invite.invitation_token }

      before(:each) { subject }

      it 'claims invite by invited student' do
        expect(invite.reload.recipient).to eq(student)
      end

      it 'binds invited student to the group in invite' do
        expect(invite.group).to eq(student.reload.group)
      end

      context 'student with group' do
        let_it_be(:student) { create(:student, :group_member) }

        it 'rebinds student group to the group from invite' do
          expect(student.reload.group).to eq(invite.group)
        end
      end
    end

    context 'invalid invite token' do
      let_it_be(:student) { create(:student) }

      context 'nil token' do
        let(:token) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'not existed token' do
        let(:token) { 'wat_token' }

        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    context 'invalid student' do
      let_it_be(:invited_student)   { create(:student) }
      let_it_be(:invite)            { create(:invite, :rnd_group, email: invited_student.user.email) }
      let_it_be(:token)             { invite.invitation_token }

      context 'nil student' do
        let(:student) { nil }

        it { expect { subject }.to raise_error(Api::ArgumentMissing) }
      end

      context 'student not from invite' do
        let(:student) { create(:student) }

        it 'return invite without bound recipient' do
          expect(subject.recipient).to be(nil)
        end

        it 'does not bind student to the group in invite' do
          expect(subject.group).to_not eq(invited_student.reload.group)
        end
      end
    end
  end
end
