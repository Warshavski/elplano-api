# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PasswordContract do
  include_context :contract_validation

  let_it_be(:default_params) do
    {
      password: 'password',
      password_confirmation: 'password confirmation'
    }
  end

  it_behaves_like :valid

  it_behaves_like :invalid, without: :password
  it_behaves_like :invalid, without: :password_confirmation
end
