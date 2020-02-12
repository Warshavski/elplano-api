# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AboutController, type: :request do

  let_it_be(:endpoint) { '/' }

  describe 'GET #show' do
    before do
      allow(Information::Compose).to receive(:call).and_return({'wat' => 'so'} )
    end

    before(:each) { get endpoint }

    it { expect(response).to have_http_status(:ok) }

    it { expect(response.body).to look_like_json }

    it { expect(body_as_json).to eq('meta' => { 'wat' => 'so'}) }
  end
end
