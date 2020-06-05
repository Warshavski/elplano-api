# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessTokens::Clear do
  describe '.call' do
    subject { described_class.call(2) }

    let_it_be(:user) { create(:user) }

    let_it_be(:outdated_token) do
      create(:token, created_at: Date.current - 3.days, resource_owner_id: user.id)
    end

    let_it_be(:actual_token) do
      create(:token, resource_owner_id: user.id)
    end

    it { expect { subject }.to change(Doorkeeper::AccessToken, :count).by(-1) }
  end
end
