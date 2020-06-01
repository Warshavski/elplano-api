# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaginationContract do
  include_context :contract_validation

  let(:default_params) do
    {
      size: 1,
      last_id: 1,
      direction: 'asc',
      field: 'any_field',
      field_value: 'wat',
      number: 1
    }
  end

  it_behaves_like :valid

  it_behaves_like :valid, without: :size
  it_behaves_like :valid, without: :last_id
  it_behaves_like :valid, without: :direction
  it_behaves_like :valid, without: :field
  it_behaves_like :valid, without: :field_value
  it_behaves_like :valid, without: :number

  it_behaves_like :invalid, with: { size: 0 }
  it_behaves_like :invalid, with: { size: 101 }
  it_behaves_like :invalid, with: { size: 'asd' }
  it_behaves_like :invalid, with: { last_id: -1 }
  it_behaves_like :invalid, with: { direction: 'pom' }
  it_behaves_like :invalid, with: { direction: 123 }
  it_behaves_like :invalid, with: { field: 123 }
  it_behaves_like :invalid, with: { number: 0 }
  it_behaves_like :invalid, with: { number: 'wat' }
end
