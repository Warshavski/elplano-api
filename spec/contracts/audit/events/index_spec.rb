# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audit::Events::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    {
      type: 'authentication'
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :type

  AuditEvent.audit_types.keys.each { |type| it_behaves_like :valid, with: { type: type } }

  it_behaves_like :invalid, with: { type: 'wat' }
  it_behaves_like :invalid, with: { type: '' }
  it_behaves_like :invalid, with: { type: nil }
end
