# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BugReport, type: :model do
  describe 'associations' do
    it { should belong_to(:reporter).class_name('User').inverse_of(:reported_bugs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:message) }

    it { should validate_presence_of(:reporter) }
  end
end
