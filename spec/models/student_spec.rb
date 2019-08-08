# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }

    it { should belong_to(:group).optional }

    it do
      should have_many(:classmates)
         .class_name('Student')
         .through(:group)
         .source(:students)
         .inverse_of(:group)
    end

    it do
      should have_one(:supervised_group)
        .class_name('Group')
        .with_foreign_key(:president_id)
        .dependent(:destroy)
    end

    it do
      have_many(:created_events)
        .class_name('Event')
        .dependent(:delete_all)
    end

    it do
      have_many(:sent_invites)
        .class_name('Invite')
        .with_foreign_key(:sender_id)
        .dependent(:destroy)
    end

    it do
      have_many(:invitations)
        .class_name('Invite')
        .with_foreign_key(:recipient_id)
        .dependent(:destroy)
    end

    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { validate_length_of(:full_name).is_at_most(200) }

    it { validate_length_of(:email).is_at_most(100) }

    it { validate_length_of(:phone).is_at_most(50) }
  end

  describe '#email' do
    it { should allow_values('wat@email.com').for(:email) }

    it { should_not allow_values('', 'wat', 'local.wat', nil).for(:email) }
  end

  context 'scopes' do
    describe '.presidents' do
      let_it_be(:student) { create(:student) }

      it 'returns only user with president privileges' do
        president = create(:president)

        expect(described_class.presidents).to eq([president])
      end

      it 'returns nothing if presidents not present' do
        expect(described_class.presidents).to eq([])
      end
    end
  end

  describe '#any_group?' do
    subject { student.any_group? }

    context 'no groups' do
      let(:student) { create(:student) }

      it { expect(subject).to be false }
    end

    context 'has supervised group' do
      let_it_be(:student) { create(:student, :group_supervisor) }

      it { expect(subject).to be true }
    end

    context 'has group' do
      let(:student) { create(:student, :group_member) }

      it { expect(subject).to be true }
    end
  end

  describe '#group_owner?' do
    subject { student.group_owner? }

    context 'no groups' do
      let(:student) { create(:student) }

      it { expect(subject).to be false }
    end

    context 'has supervised group' do
      let_it_be(:student) { create(:student, :group_supervisor) }

      it { expect(subject).to be true }
    end

    context 'has group' do
      let(:student) { create(:student, :group_member) }

      it { expect(subject).to be false }
    end
  end
end
