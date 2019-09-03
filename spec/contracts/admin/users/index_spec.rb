# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    { status: 'banned' }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :status

  User::STATUSES.each { |status| it_behaves_like :valid, with: { status: status } }

  it_behaves_like :invalid, with: { status: 'wat' }
  it_behaves_like :invalid, with: { status: '' }
  it_behaves_like :invalid, with: { status: nil }
end
