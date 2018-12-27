require 'rails_helper'

describe ApplicationController do
  let(:user) { create(:user) }

  describe 'response format' do
    controller(described_class) do
      def index
        head :ok
      end
    end

    before { sign_in user }

    context 'when format is handled' do
      it 'returns 200 response' do
        get :index, format: :json

        expect(response).to have_http_status :ok
      end
    end

    context 'when format is not handled' do
      it 'returns 404 response' do
        get :index

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#route_not_found' do
    it 'renders 404 if authenticated' do
      allow(controller).to receive(:current_user).and_return(user)

      expect(controller).to receive(:not_found)

      controller.send(:route_not_found)
    end

    it 'does redirect to login page via authenticate_user! if not authenticated' do
      allow(controller).to receive(:current_user).and_return(nil)

      expect(controller).to receive(:authenticate_user!)

      controller.send(:route_not_found)
    end
  end
end
