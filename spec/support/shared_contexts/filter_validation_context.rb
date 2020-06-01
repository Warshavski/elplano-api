# frozen_string_literal: true

RSpec.shared_context :filter_validation do
  include_context :contract_validation

  let(:default_params) do
    { search: 'term' }
  end

  it_behaves_like :valid

  it_behaves_like :valid, without: :search

  it_behaves_like :invalid, with: { search: 123 }
  it_behaves_like :invalid, with: { search: '' }
  it_behaves_like :invalid, with: { search: nil }
end
