# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:identity) }

    it { should validate_presence_of(:provider) }

    it { should validate_uniqueness_of(:uid).scoped_to(%i[user_id]).case_insensitive }

    it do
      should define_enum_for(:provider)
               .with_values(google: 10, facebook: 20, vk: 30, yandex: 40)
               .backed_by_column_of_type(:integer)
    end
  end
end
