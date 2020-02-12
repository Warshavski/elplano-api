# frozen_string_literal: true

require 'rails_helper'

#
#  root GET   /   about#show {:format=>"json"}
#
describe AboutController, 'routing' do
  it 'routes to #show' do
    expect(get('/')).to route_to('about#show', format: 'json')
  end
end
