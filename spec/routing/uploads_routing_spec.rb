# frozen_string_literal: true

require 'rails_helper'

#
#   uploads POST   /uploads(.:format)   uploads#create
#
RSpec.describe UploadsController, 'routing' do
  it 'routes to #create' do
    expect(post('/uploads')).to route_to('uploads#create')
  end
end
