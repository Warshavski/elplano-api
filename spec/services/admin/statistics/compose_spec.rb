# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Statistics::Compose do
  before do
    allow(Date).to(
      receive_message_chain(:current, :beginning_of_week).and_return(Date.parse('2019-10-07'))
    )

    allow(Date).to(
      receive_message_chain(:current, :beginning_of_month).and_return(Date.parse('2019-10-01'))
    )
  end


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
          week_count: 2,
          month_count: 2
        }
      }
    end

    it { is_expected.to eq(expected_stats) }
  end
end
