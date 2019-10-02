# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accomplishment, type: :model do
  describe 'associations' do
    it { should belong_to(:student) }

    it { should belong_to(:assignment) }

    it { should have_many(:attachments).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:accomplishment) }

    it { should validate_uniqueness_of(:assignment_id).scoped_to(%i[student_id]) }
  end
end
