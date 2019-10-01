# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignments::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    { outdated: false }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :outdated

  [true, false].each { |flag| it_behaves_like :valid, with: { outdated: flag } }

  it_behaves_like :invalid, with: { outdated: 'wat' }
  it_behaves_like :invalid, with: { outdated: 'false' }
  it_behaves_like :invalid, with: { outdated: 'true' }
  it_behaves_like :invalid, with: { outdated: 0 }
  it_behaves_like :invalid, with: { outdated: 1 }
  it_behaves_like :invalid, with: { outdated: nil }
end
