require 'rails_helper'

RSpec.describe Lecture, type: :model do
  describe 'associations' do
    it { should belong_to(:lecturer) }

    it { should belong_to(:course) }
  end
end
