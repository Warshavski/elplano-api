require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'associations' do
    it { should belong_to(:group) }

    it { should have_many(:lectures).dependent(:delete_all) }

    it { should have_many(:lecturers).through(:lectures) }

    it { should have_many(:events).dependent(:nullify) }
  end

  describe 'validations' do
    subject { create(:course) }

    it { should validate_presence_of(:title) }

    it { should validate_length_of(:title).is_at_most(200) }

    it do
      should validate_uniqueness_of(:title).scoped_to(%i[group_id]).case_insensitive
    end
  end

  context 'callbacks' do
    describe 'before_validation' do
      let_it_be(:subject) do
        create(:course, title: 'lOoK MA DiFFeReNt_CasE')
      end

      it { expect(subject.title).to eq('look ma different_case') }
    end
  end
end
