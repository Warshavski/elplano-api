require 'rails_helper'

RSpec.describe Invite, type: :model do
  describe 'associations' do
    it { should belong_to(:group) }

    it { should belong_to(:sender).class_name('Student') }

    it { should belong_to(:recipient).class_name('Student').optional }
  end

  describe 'validations' do
    subject { build(:invite, :rnd_group) }

    it { should validate_presence_of(:group) }

    it { should validate_presence_of(:sender) }

    it { should validate_presence_of(:recipient).on(:update) }

    it { should validate_uniqueness_of(:invitation_token).allow_blank }

    it { should validate_uniqueness_of(:email).scoped_to(:group_id).case_insensitive }
  end

  context 'callbacks' do
    describe 'before_create' do
      let_it_be(:subject) { create(:invite, :rnd_group) }

      it { expect(subject.invitation_token).to_not be(nil) }

      it { expect(subject.sent_at).to_not be(nil) }
    end

    describe 'before_validation' do
      let_it_be(:subject) { create(:invite, :rnd_group, email: 'WaT@eMAil.EX') }

      it { expect(subject.email).to eq('wat@email.ex') }
    end
  end

  describe '#email' do
    it { should allow_values('wat@email.com').for(:email) }

    it { should_not allow_values('', 'wat', 'local.wat', nil).for(:email) }
  end

  describe '#claim_by!' do
    let(:invite) { create(:invite, :rnd_group) }

    subject { invite.claim_by!(student) }

    context 'existed user' do
      let(:student) { create(:student) }

      before(:each) { subject }

      it { expect(invite.invitation_token).to be(nil) }

      it { expect(invite.accepted_at).to_not be(nil) }

      it { expect(invite.recipient).to eq(student) }
    end

    context 'nil student' do
      let(:student) { nil }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end

  describe '#accepted?' do
    subject { invite.accepted? }

    context 'accepted invite' do
      let_it_be(:invite) { create(:invite, :rnd_group, :accepted) }

      it { expect(subject).to be(true) }
    end

    context 'not accepted invite' do
      let_it_be(:invite) { create(:invite, :rnd_group) }

      it { expect(subject).to be(false) }
    end
  end
end
