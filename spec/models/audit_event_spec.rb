# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditEvent, type: :model do
  context 'associations' do
    it do
      should belong_to(:author)
               .with_foreign_key(:author_id)
               .class_name('User')
               .inverse_of(:audit_events)
    end

    it { should belong_to(:entity) }
  end

  context 'validations' do
    it { should validate_presence_of(:author_id) }

    it { should validate_presence_of(:entity_id) }

    it { should validate_presence_of(:entity_type) }

    it do
      should define_enum_for(:audit_type)
               .with_values(authentication: 1, permanent_action: 2)
               .backed_by_column_of_type(:integer)
    end
  end

  context 'scopes' do
    describe '.by_type' do
      let_it_be(:user) { create(:user) }

      let_it_be(:type) { 'authentication' }

      let_it_be(:authentication_event) do
        create(:audit_event, :authentication, author: user, entity: user)
      end

      let_it_be(:permanent_event) do
        create(:audit_event, :permanent_action, author: user, entity: user)
      end

      subject { described_class.by_type(type) }

      it { is_expected.to eq([authentication_event]) }
    end
  end
end
