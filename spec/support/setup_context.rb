RSpec.shared_context 'shared setup' do
  let(:user)  { create(:user) }
  let(:token) { create(:token, resource_owner_id: user.id) }

  let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }
end


