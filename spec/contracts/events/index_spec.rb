# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    {
      labels: 'banned',
      type: 'group',
      scope: 'authored'
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :type
  it_behaves_like :valid, without: :scope
  it_behaves_like :valid, without: :labels

  %w[authored appointed].each { |status| it_behaves_like :valid, with: { scope: status } }
  %w[group personal].each { |status| it_behaves_like :valid, with: { type: status } }

  it_behaves_like :invalid, with: { scope: 'wat' }
  it_behaves_like :invalid, with: { scope: '' }
  it_behaves_like :invalid, with: { scope: nil }

  it_behaves_like :invalid, with: { type: 'wat' }
  it_behaves_like :invalid, with: { type: '' }
  it_behaves_like :invalid, with: { type: nil }

  it_behaves_like :valid, with: { labels: 'wat,so' }
  it_behaves_like :invalid, with: { labels: '' }
  it_behaves_like :invalid, with: { labels: nil }
end
