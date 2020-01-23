# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identities::CreateContract do
  include_context :contract_validation

  let_it_be(:default_params) do
    { provider: 'vk', code: 'code', redirect_uri: 'http://localhost:300' }
  end

  it_behaves_like :valid

  Identity.providers.keys.each { |provider| it_behaves_like :valid, with: { provider: provider } }

  it_behaves_like :invalid, with: { provider: 'wat' }
  it_behaves_like :invalid, with: { provider: '' }
  it_behaves_like :invalid, with: { provider: nil }

  it_behaves_like :invalid, with: { code: '' }
  it_behaves_like :invalid, with: { code: nil }

  it_behaves_like :invalid, with: { redirect_uri: '' }
  it_behaves_like :invalid, with: { redirect_uri: nil }

  it_behaves_like :invalid, without: :code
  it_behaves_like :invalid, without: :provider
  it_behaves_like :invalid, without: :redirect_uri
end
