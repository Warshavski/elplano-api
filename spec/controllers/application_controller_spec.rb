# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  let_it_be(:user) { create(:user) }

  let_it_be(:token) { create(:token, resource_owner_id: user.id) }

  describe 'service error' do
    controller(described_class) do
      def index
        raise StandardError, 'Whoops!'
      end
    end

    before do
      allow(controller).to receive(:doorkeeper_token) { token }
    end

    it 'returns 500 response' do
      request.headers.merge('Content-Type' => 'application/vnd.api+json')

      get :index, format: :json

      expected_body = {
        errors:[
          {
            status: 500,
            detail: "(ノಠ益ಠ)ノ彡┻━┻",
            source: {
              pointer: "server"
            }
          }
        ]
      }

      expect(response).to have_http_status(:server_error)
      expect(response.body).to eq(expected_body.to_json)
    end
  end

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
        request.headers.merge('Content-Type' => 'application/vnd.api+json')
        get :index, format: :json

        expect(response).to have_http_status :ok
      end
    end

    context 'when format is not handled' do
      it 'returns 415 response' do
        get :index

        expect(response).to have_http_status :unsupported_media_type
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

      expect(controller).to receive(:authorize_access!)

      controller.send(:route_not_found)
    end
  end

  describe '#configure_title_header' do
    let(:controller) { described_class.new }

    it 'URI encodes UTF-8 characters in the title' do
      response = double(headers: {})
      allow(controller).to receive(:response).and_return(response)

      controller.send(:configure_title_header)

      expect(response.headers['Endpoint-Title']).to eq('El%20Plano')
    end
  end

  describe '#json_content_type?' do
    let(:controller) { described_class.new }
    let(:request)    { double(content_type: content_type) }

    subject { controller.send(:json_content_type?) }

    before do
      allow(controller).to receive(:request).and_return(request)
    end

    context 'not json content-type' do
      let(:content_type) { 'text' }

      it { expect(subject).to be false }
    end

    context 'application/json' do
      let(:content_type) { 'application/json' }

      it { expect(subject).to be true }
    end

    context 'text/x-json' do
      let(:content_type) { 'text/x-json' }

      it { expect(subject).to be true }
    end

    context 'application/vnd.api+json' do
      let(:content_type) { 'application/vnd.api+json' }

      it { expect(subject).to be true }
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

  describe '#current_student' do
    let_it_be(:student) { create(:student, user: user) }

    it 'returns student info of authenticated user' do
      allow(controller).to receive(:current_user).and_return(user)

      current_student = controller.send(:current_student)

      expect(current_student).to eq student
    end
  end

  describe '#current_group' do
    let_it_be(:student) { create(:student, :group_member) }

    it 'returns student info of authenticated user' do
      allow(controller).to receive(:current_student).and_return(student)

      current_group = controller.send(:current_group)

      expect(current_group).to eq student.group
    end
  end

  describe '#supervised_group' do
    let_it_be(:student) { create(:student, :group_supervisor) }

    it 'returns student info of authenticated user' do
      allow(controller).to receive(:current_student).and_return(student)

      supervised_group = controller.send(:supervised_group)

      expect(supervised_group).to eq student.supervised_group
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
