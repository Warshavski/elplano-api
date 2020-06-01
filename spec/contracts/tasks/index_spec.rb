# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::IndexContract do
  include_context :filter_validation

  let(:default_params) do
    {
      expiration: 'active',
      accomplished: true,
      appointed: false,
      event_id: 2
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :outdated

  Task::EXPIRATION_SCOPES.each { |scope| it_behaves_like :valid, with: { expiration: scope } }

  it_behaves_like :invalid, with: { expiration: 'wat' }
  it_behaves_like :invalid, with: { expiration: '' }
  it_behaves_like :invalid, with: { expiration: nil }

  it_behaves_like :valid, with: { event_id: 1 }
  it_behaves_like :invalid, with: { event_id: 'wat' }
  it_behaves_like :invalid, with: { event_id: nil }

  [true, false].each { |flag| it_behaves_like :valid, with: { accomplished: flag } }

  it_behaves_like :invalid, with: { accomplished: 'wat' }
  it_behaves_like :valid, with: { accomplished: 'false' }
  it_behaves_like :valid, with: { accomplished: 'true' }
  it_behaves_like :valid, with: { accomplished: 0 }
  it_behaves_like :valid, with: { accomplished: 1 }
  it_behaves_like :invalid, with: { accomplished: nil }

  [true, false].each { |flag| it_behaves_like :valid, with: { appointed: flag } }

  it_behaves_like :invalid, with: { appointed: 'wat' }
  it_behaves_like :valid, with: { appointed: 'false' }
  it_behaves_like :valid, with: { appointed: 'true' }
  it_behaves_like :valid, with: { appointed: 0 }
  it_behaves_like :valid, with: { appointed: 1 }
  it_behaves_like :invalid, with: { appointed: nil }
end
