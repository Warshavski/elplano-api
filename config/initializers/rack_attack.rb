relative_root_url = Rails.application.config.relative_url_root

protected_paths = %W(
  #{relative_root_url}/oauth/token
  #{relative_root_url}/api/v1/users
  #{relative_root_url}/api/v1/users/sign_in
  #{relative_root_url}/api/v1/users/password
  #{relative_root_url}/api/v1/users/unlock
  #{relative_root_url}/api/v1/users/confirmation
)

#
# Create one big regular expression that matches strings starting with any of the protected_paths.
#
paths_regex = Regexp.union(protected_paths.map { |path| /\A#{Regexp.escape(path)}/ })

unless Rails.env.test?
  Rack::Attack.throttle('protected paths', limit: 10, period: 60.seconds) do |req|
    if req.post? && req.path =~ paths_regex
      req.ip
    end
  end

  @ip_whitelist ||= Elplano.config.rack_attack['ip_whitelist'].map(&IPAddr.method(:new))

  Rack::Attack.safelist('allow') do |req|
    @ip_whitelist.any? { |e| e.include?(req.ip) }
  end
end
