# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity::Events::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    {
      action: 'created'
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :action

  ActivityEvent.actions.keys.each { |action| it_behaves_like :valid, with: { action: action } }

  it_behaves_like :invalid, with: { action: 'wat' }
  it_behaves_like :invalid, with: { action: '' }
  it_behaves_like :invalid, with: { action: nil }
end
