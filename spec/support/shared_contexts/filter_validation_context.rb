# frozen_string_literal: true

RSpec.shared_context :filter_validation do
  include_context :contract_validation

  let(:default_params) do
    {
      limit: 1,
      last_id: 1,
      direction: 'asc',
      field: 'any_field',
      field_value: 'wat',
      page: 1
    }
  end

  it_behaves_like :valid

  it_behaves_like :valid, without: :limit
  it_behaves_like :valid, without: :last_id
  it_behaves_like :valid, without: :direction
  it_behaves_like :valid, without: :field
  it_behaves_like :valid, without: :field_value
  it_behaves_like :valid, without: :search
  it_behaves_like :valid, without: :page

  it_behaves_like :invalid, with: { limit: 0 }
  it_behaves_like :invalid, with: { limit: 101 }
  it_behaves_like :invalid, with: { limit: 'asd' }
  it_behaves_like :invalid, with: { last_id: -1 }
  it_behaves_like :invalid, with: { direction: 'pom' }
  it_behaves_like :invalid, with: { direction: 123 }
  it_behaves_like :invalid, with: { field: 123 }
  it_behaves_like :invalid, with: { search: 123 }
  it_behaves_like :invalid, with: { search: '' }
  it_behaves_like :invalid, with: { search: nil }
  it_behaves_like :invalid, with: { page: 0 }
  it_behaves_like :invalid, with: { page: 'wat' }
end
