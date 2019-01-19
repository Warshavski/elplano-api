require 'rails_helper'

describe ApplicationController do
  let(:user) { create(:user) }

  let!(:token) { create(:token, resource_owner_id: user.id) }

  describe 'response format' do
    controller(described_class) do
      def index
        head :ok
      end
    end

    before do
      allow(controller).to receive(:doorkeeper_token) { token }
    end

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

      expect(controller).to receive(:doorkeeper_authorize!)

      controller.send(:route_not_found)
    end
  end

  describe '#set_page_title_header' do
    let(:controller) { described_class.new }

    it 'URI encodes UTF-8 characters in the title' do
      response = double(headers: {})
      allow(controller).to receive(:response).and_return(response)

      controller.send(:set_page_title_header)

      expect(response.headers['Page-Title']).to eq('El+Plano')
    end
  end

  describe '#current_user' do
    it 'returns nil' do
      allow(controller).to receive(:doorkeeper_token).and_return(nil)

      current_user = controller.send(:current_user)

      expect(current_user).to be nil
    end

    it 'returns authenticated user' do
      allow(controller).to receive(:doorkeeper_token).and_return(token)

      current_user = controller.send(:current_user)

      expect(current_user).to eq user
    end
  end

  describe '#current_user' do
    let!(:student) { create(:student, user: user) }

    it 'returns student info of authenticated user' do
      allow(controller).to receive(:current_user).and_return(user)

      current_student = controller.send(:current_student)

      expect(current_student).to eq student
    end
  end

  context 'control headers' do
    controller(described_class) do
      def index
        render json: :ok
      end
    end

    it 'sets the default headers' do
      get :index

      expect(response.headers['Cache-Control']).to eq 'private, no-store'
    end
  end
end
