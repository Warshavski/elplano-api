RSpec.shared_examples 'request errors examples' do
  context 'responds with a 400 status on request with empty params' do
    let(:request_params) { nil }

    it { expect(response).to have_http_status(:bad_request) }
  end

  context 'responds with a 422 status on request with not valid params' do
    let(:request_params) { invalid_request_params }

    it { expect(response).to have_http_status(:unprocessable_entity) }
  end

  context 'responds with a 401 status on not presented auth header' do
    let(:auth_header) { nil }

    it { expect(response).to have_http_status(:unauthorized) }
  end
end
