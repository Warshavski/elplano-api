# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SocialNetwork, type: :model do
  subject { build(:social_network) }

  context 'validations' do
    it_should_behave_like 'url validation'

    it 'is expected to pass validation for not empty network' do
      subject.network = 'description name'

      expect(subject).to be_valid
    end

    it 'is expected to fail validation for blank network' do
      invalid_network_values = [nil, '']

      invalid_network_values.each do |network|
        subject.network = network

        expect(subject).not_to be_valid
      end
    end
  end
end
