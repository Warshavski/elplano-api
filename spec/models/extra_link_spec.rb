# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtraLink, type: :model do
  subject { build(:extra_link) }

  context 'validations' do
    it_should_behave_like 'url validation'

    it 'is expected to pass validation for not empty description' do
      subject.description = 'description name'

      expect(subject).to be_valid
    end

    it 'is expected to pass validation for blank description' do
      invalid_service_values = [nil, '']

      invalid_service_values.each do |description|
        subject.description = description

        expect(subject).to be_valid
      end
    end
  end
end
