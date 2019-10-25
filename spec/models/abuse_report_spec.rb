# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbuseReport, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:reporter).class_name('User').inverse_of(:reported_abuses) }

    it { is_expected.to belong_to(:user).inverse_of(:abuse_report) }
  end

  context 'validations' do
    it { should validate_presence_of(:message) }

    it { should validate_presence_of(:reporter) }

    it { should validate_presence_of(:user) }
  end
end
