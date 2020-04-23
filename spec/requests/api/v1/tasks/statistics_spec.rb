# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Tasks::StatisticsController, type: :request do
  include_context 'shared setup'

  subject { get '/api/v1/tasks/statistics', headers: headers }

  before do
    allow(Date).to receive(:current).and_return(current_date)
  end

  let_it_be(:current_date) { Date.parse('2019-09-30') }

  let_it_be(:author)  { create(:student, :group_supervisor) }
  let_it_be(:student) { create(:student, group: author.group, user: user) }
  let_it_be(:event)   { create(:event, eventable: student.group) }

  let_it_be(:expired) do
    create_list(
      :task, 2, :skip_validation,
      event: event, author: student, students: [student], expired_at: current_date - 1.day
    )
  end

  let_it_be(:active) do
    create(
      :task, :skip_validation,
      event: event, author: student, students: [student], expired_at: current_date + 3.days
    )
  end

  let_it_be(:without_expiration) do
    create(:task, event: event, author: student, students: [student], expired_at: nil)
  end

  let_it_be(:today) do
    create_list(
      :task, 3, :skip_validation,
      event: event, author: student, students: [student], expired_at: current_date
    )
  end

  let_it_be(:tomorrow) do
    create(
      :task, :skip_validation,
      event: event, author: student, students: [student], expired_at: current_date + 1.day
    )
  end

  before(:each) { subject }

  describe 'GET #show' do
    context 'when user is authorized user' do
      it 'is expected to return meta with grouped counters data' do
        expect(response).to have_http_status(:ok)

        expected_json = {
          'meta' => {
            'outdated_count' => 2,
            'today_count' => 3,
            'tomorrow_count' => 1,
            'upcoming_count' => 1,
            'accomplished_count' => 0
          }
        }

        expect(body_as_json).to eq(expected_json)
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
