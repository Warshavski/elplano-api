# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AnnouncementsController, type: :request do
  include_context 'shared setup'

  subject { get '/api/v1/announcements', headers: headers }

  let_it_be(:announcement) { create(:announcement) }

  before(:each) { subject }

  describe 'GET #index' do
    context 'when user is authorized user' do
      it 'is expected to respond with announcements list' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to eq(1)
        expect(json_data.map { |e| e[:type] }).to match_array(['announcement'])

        entity = json_data.first

        expected_attributes = %w[
          message background_color foreground_color
          start_at end_at created_at updated_at
        ]

        expect(entity[:attributes].keys).to match_array(expected_attributes)
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
