Rails.application.configure do |_|
  Warden::Manager.after_authentication(scope: :user) do |user, _auth, _opts|
    ActiveToken.cleanup(user)
  end

  Warden::Manager.after_set_user(scope: :user, only: :fetch) do |user, auth, opts|
    ActiveToken.set(user, opts[:token].token, auth.request)
  end

  Warden::Manager.before_logout(scope: :user) do |user, auth, _opts|
    access_token = auth.request.headers['Authorization']&.split(' ')&.last

    ActiveToken.destroy(user, access_token) unless access_token.nil?
  end
end
