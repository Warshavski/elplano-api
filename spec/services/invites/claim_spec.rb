require 'rails_helper'

RSpec.describe Invites::Claim do
  describe '.call' do
    subject { described_class.call(user, token) }

    context 'valid invite' do
      let(:user)    { create(:user, :student) }
      let(:invite)  { create(:invite, :rnd_group, email: user.email) }
      let(:token)   { invite.invitation_token }

      before(:each) { subject }

      it 'claims invite by invited user' do
        expect(invite.reload.recipient).to eq(user)
      end

      it 'binds invited user to the group in invite' do
        expect(invite.group).to eq(user.student.reload.group)
      end

      context 'user with group' do
        let_it_be(:user) { create(:student, :group_member).user }

        it 'rebinds user group to the group from invite' do
          expect(user.student.reload.group).to eq(invite.group)
        end
      end
    end

    context 'invalid invite token' do
      let_it_be(:user) { create(:user, :student) }

      context 'nil token' do
        let(:token) { nil }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'not existed token' do
        let(:token) { 'wat_token' }

        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end

    context 'invalid user' do
      let_it_be(:invited_user)  { create(:user, :student) }
      let_it_be(:invite)        { create(:invite, :rnd_group, email: invited_user.email) }
      let_it_be(:token)         { invite.invitation_token }

      context 'nil user' do
        let(:user) { nil }

        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'user not from invite' do
        let(:user) { create(:user, :student) }

        it 'return invite without bound recipient' do
          expect(subject.recipient).to be(nil)
        end

        it 'does not bind user to the group in invite' do
          expect(subject.group).to_not eq(invited_user.student.reload.group)
        end
      end
    end
  end
end
