require 'rails_helper'

#
## native_oauth_authorization GET    /oauth/authorize/native(.:format)  doorkeeper/authorizations#show
#        oauth_authorization GET    /oauth/authorize(.:format)          doorkeeper/authorizations#new
#                            DELETE /oauth/authorize(.:format)          doorkeeper/authorizations#destroy
#                            POST   /oauth/authorize(.:format)          doorkeeper/authorizations#create
#
describe Doorkeeper::AuthorizationsController, 'routing' do
  it 'routes to #show' do
    expect(get('/oauth/authorize/native')).to route_to('doorkeeper/authorizations#show')
  end

  it 'routes to #new' do
    expect(get('/oauth/authorize')).to route_to('doorkeeper/authorizations#new')
  end

  it 'routes to #destroy' do
    expect(delete('/oauth/authorize')).to route_to('doorkeeper/authorizations#destroy')
  end

  it 'routes to #create' do
    expect(post('/oauth/authorize')).to route_to('doorkeeper/authorizations#create')
  end
end

#                oauth_token POST   /oauth/token(.:format)       doorkeeper/tokens#create
#               oauth_revoke POST   /oauth/revoke(.:format)      doorkeeper/tokens#revoke
#           oauth_introspect POST   /oauth/introspect(.:format)  doorkeeper/tokens#introspect
#           oauth_token_info GET    /oauth/token/info(.:format)  doorkeeper/token_info#show
#
describe Doorkeeper::TokensController, 'routing' do
  it 'routes to #create' do
    expect(post('/oauth/token')).to route_to('doorkeeper/tokens#create')
  end

  it 'routes to #create' do
    expect(post('/oauth/revoke')).to route_to('doorkeeper/tokens#revoke')
  end

  it 'routes to #create' do
    expect(post('/oauth/introspect')).to route_to('doorkeeper/tokens#introspect')
  end

  it 'routes to #show' do
    expect(get('/oauth/token/info')).to route_to('doorkeeper/token_info#show')
  end
end

