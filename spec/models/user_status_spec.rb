# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserStatus, type: :model do
  describe 'associations' do
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }

    it { should validate_length_of(:message).is_at_most(100) }

    describe '#emoji' do
      it { should allow_values('cat', 'speech_balloon').for(:emoji) }

      it { should_not allow_values('', 'wat', '43we', nil).for(:emoji) }
    end
  end
end
