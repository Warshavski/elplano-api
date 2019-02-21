RSpec.shared_context 'shared setup' do
  let_it_be(:user)  { create(:user) }
  let_it_be(:token) { create(:token, resource_owner_id: user.id) }

  let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }
end


