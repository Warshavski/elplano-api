# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
  end
end
