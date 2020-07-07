# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lecturer, type: :model do
  describe 'associations' do
    it { should belong_to(:group) }

    it { should have_many(:lectures).dependent(:delete_all) }

    it { should have_many(:courses).through(:lectures) }
  end

  describe 'validations' do
    subject { create(:lecturer) }

    it { should validate_presence_of(:first_name) }

    it { should validate_presence_of(:last_name) }

    it { should validate_presence_of(:patronymic) }

    it { should validate_length_of(:first_name).is_at_most(40) }

    it { should validate_length_of(:last_name).is_at_most(40) }

    it { should validate_length_of(:patronymic).is_at_most(40) }

    it do
      should validate_uniqueness_of(:group_id)
               .scoped_to(%i[first_name last_name patronymic])
               .case_insensitive
    end

    describe '#email' do
      it { should allow_values('wat@email.com').for(:email) }

      it { should allow_values(nil).for(:email) }

      it { should_not allow_values('', 'wat', 'local.wat').for(:email) }
    end
  end

  context 'callbacks' do
    describe 'before_validation' do
      let_it_be(:subject) do
        create(:lecturer, first_name: 'lOoK', last_name: 'MA', patronymic: 'DiFFeReNt_CasE', email: 'StraNgE@eMAil')
      end

      it 'is expected to normalize name attributes' do
        expect(subject.first_name).to eq('look')
        expect(subject.last_name).to eq('ma')
        expect(subject.patronymic).to eq('different_case')
        expect(subject.email).to eq('strange@email')
      end
    end
  end

  it_behaves_like 'deactivatable'
end
