require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    it { should belong_to(:president).class_name('Student') }

    it { should have_many(:students).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:number) }

    it { should validate_length_of(:number).is_at_most(25) }

    it { should validate_length_of(:title).is_at_most(200) }
  end
end
