# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Activity::Events::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    {
      action: 'created',
      author_id: 1
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :action
  it_behaves_like :valid, without: :author_id

  ActivityEvent.actions.keys.each { |action| it_behaves_like :valid, with: { action: action } }

  it_behaves_like :invalid, with: { action: 'wat' }
  it_behaves_like :invalid, with: { action: '' }
  it_behaves_like :invalid, with: { action: nil }

  it_behaves_like :invalid, with: { author_id: 'wat' }
  it_behaves_like :valid, with: { author_id: '1' }
  it_behaves_like :invalid, with: { author_id: '' }
  it_behaves_like :invalid, with: { author_id: nil }
end
