# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityEvent, type: :model do
  describe 'associations' do
    it do
      should belong_to(:author)
               .with_foreign_key(:author_id)
               .class_name('User')
               .inverse_of(:activity_events)
    end

    it { should belong_to(:target) }
  end

  describe 'validations' do
    it { should validate_presence_of(:author_id) }

    it { should validate_presence_of(:target_id) }

    it { should validate_presence_of(:target_type) }

    it { should validate_inclusion_of(:target_type).in_array(described_class::TARGETS.values) }

    it do
      should define_enum_for(:action)
               .with_values(created: 1, updated: 2)
               .backed_by_column_of_type(:integer)
    end
  end

  context 'scopes' do
    describe '.by_action' do
      subject { described_class.by_action(:created) }

      let_it_be(:assignment)  { create(:assignment) }
      let_it_be(:user)        { assignment.student.user }

      let_it_be(:created_event) do
        create(:activity_event, :created, author: user, target: assignment)
      end

      let_it_be(:updated_event) do
        create(:activity_event, :updated, author: user, target: assignment)
      end

      it { is_expected.to eq([created_event]) }
    end
  end
end
