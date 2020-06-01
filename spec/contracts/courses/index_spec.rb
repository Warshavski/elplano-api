# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Courses::IndexContract do
  include_context :filter_validation

  it_behaves_like :valid, without: :active

  [true, false].each { |status| it_behaves_like :valid, with: { active: status } }

  it_behaves_like :invalid, with: { active: nil }
  it_behaves_like :invalid, with: { active: 'wat' }
  it_behaves_like :invalid, with: { active: '' }
  it_behaves_like :valid, with: { active: 'false' }
  it_behaves_like :valid, with: { active: 'true' }
  it_behaves_like :valid, with: { active: 1 }
  it_behaves_like :valid, with: { active: 0 }
end
