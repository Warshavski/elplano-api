# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditEvents::Log do
  describe '.call' do
    subject { described_class.new(author, entity, details).execute(type) }

    let_it_be(:user) { create(:user) }
    let_it_be(:author) { user }
    let_it_be(:entity) { user }
    let_it_be(:details) { { with: 'standard' } }

    context 'when type is an authentication' do
      let_it_be(:type) { 'authentication' }

      it 'is expected to create a new audit event entity' do
        expect { subject }.to change(AuditEvent, :count).by(1)

        event = subject

        expect(event.author).to eq(author)
        expect(event.entity).to eq(entity)
        expect(event.audit_type).to eq('authentication')

        expected_details = {
          'with' => 'standard',
          'target_id' => entity.id,
          'target_type' => 'User',
          'target_details' => entity.username
        }

        expect(event.details).to eq(expected_details)
      end
    end
  end
end
