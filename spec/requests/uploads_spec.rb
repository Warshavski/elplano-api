# frozen_string_literal: true

require 'rails_helper'

describe UploadsController do
  include_context 'shared setup'

  let(:params)  { { upload: { file: file, type: type } } }
  let(:file)    { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:type)    { :avatar }

  describe 'POST #create' do
    subject { post '/uploads', params: params, headers: headers }

    before(:each) { subject }

    context 'valid request' do
      it { expect(response).to have_http_status(:created) }

      it { expect(body_as_json.keys).to match_array(%w[id storage metadata]) }

      it 'returns cached file metadata' do
        actual_metadata = body_as_json['metadata']
        expected_metadata = {
          'filename' => 'dk.png',
          'size' => 1_062,
          'mime_type' => 'image/png'
        }

        expect(actual_metadata).to eq(expected_metadata)
      end

      it 'responds with cache storage type' do
        actual_storage = body_as_json['storage']
        expected_storage = 'cache'

        expect(actual_storage).to eq(expected_storage)
      end
    end

    context 'invalid request' do
      context 'anonymous user' do
        let(:headers) { nil }

        it { expect(response).to have_http_status(:unauthorized) }

        it { expect(response.body).to eq("{\"errors\":[{\"status\":401,\"title\":\"Authorization error\",\"detail\":\"The access token is invalid\",\"source\":{\"pointer\":\"Authorization Header\"}}]}") }
      end

      context 'without file param' do
        let(:file) { nil }

        it { expect(response).to have_http_status(:bad_request) }
      end

      context 'without type param' do
        let(:type) { nil }

        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end
end
