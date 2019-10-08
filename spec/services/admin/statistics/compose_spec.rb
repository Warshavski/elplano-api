# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Statistics::Compose do
  describe '.call' do
    subject { described_class.call }

    let_it_be(:last_week_group) do
      create(:group, created_at: Date.current.beginning_of_week)
    end

    let_it_be(:last_month_group) do
      create(:group, created_at: Date.current.beginning_of_month)
    end

    let_it_be(:expected_stats) do
      {
        user: {
          total_count: 2,
          week_count: 2,
          month_count: 2
        },
        group: {
          total_count: 2,
          week_count: 1,
          month_count: 2
        }
      }
    end

    it { is_expected.to eq(expected_stats) }
  end
end
