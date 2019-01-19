require 'rails_helper'

RSpec.describe TimezoneExistenceValidator do
  let(:validator) { described_class.new(attributes: { timezone: 'Etc/GMT+122' }) }
  let(:event)     { create(:event) }

  it 'timezone exceeds allowed value' do
    validator.validate_each(event, :timezone, 'Etc/GMT+122')

    expect(event.errors).to have_key(:timezone)
  end
end