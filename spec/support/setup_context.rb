RSpec.shared_context 'shared setup' do |type|
  let_it_be(:user)  { create(type || :user) }
  let_it_be(:token) { create(:token, resource_owner_id: user.id) }

  let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }
end
