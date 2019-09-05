# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DestroyContract do
  include_context :contract_validation

  let_it_be(:default_params) { { password: 'password' } }

  it_behaves_like :valid

  it_behaves_like :invalid, without: :password
end
