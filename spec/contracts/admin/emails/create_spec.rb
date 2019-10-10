# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Emails::CreateContract do
  include_context :contract_validation

  let_it_be(:default_params) do
    { user_id: 1, type: 'unlock' }
  end

  it_behaves_like :valid

  it_behaves_like :invalid, without: :user_id
  it_behaves_like :invalid, without: :type

  User::MAILING_TYPES.each { |type| it_behaves_like :valid, with: { type: type } }
end
