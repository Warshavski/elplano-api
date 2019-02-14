RSpec.shared_context 'shared auth' do
  let(:user)        { create(:user) }
  let(:token)       { create(:token, resource_owner_id: user.id) }
  let(:auth_header) { { 'Authorization' => "Bearer #{token.token}" } }
end
