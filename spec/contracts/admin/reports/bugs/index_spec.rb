# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Reports::Bugs::IndexContract do
  include_context :filter_validation

  it_behaves_like :valid, with: { user_id: 1 }
  it_behaves_like :valid, without: :user_id

  it_behaves_like :invalid, with: { user_id: 'wat' }
  it_behaves_like :invalid, with: { user_id: '1' }
  it_behaves_like :invalid, with: { user_id: '' }
  it_behaves_like :invalid, with: { user_id: nil }
end
