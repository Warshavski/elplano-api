# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimezoneExistenceValidator do
  let_it_be(:validator) { described_class.new(attributes: { timezone: 'Etc/GMT+122' }) }
  let_it_be(:student)   { create(:student) }
  let_it_be(:event)     { create(:event, eventable: student, creator: student) }

  it 'timezone exceeds allowed value' do
    validator.validate_each(event, :timezone, 'Etc/GMT+122')

    expect(event.errors).to have_key(:timezone)
  end
end
