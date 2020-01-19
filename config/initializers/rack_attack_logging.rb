#
# Adds logging for all Rack Attack blocks and throttling events.
#
ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, wat|
  req= wat[:request]
  if [:throttle, :blacklist].include? req.env['rack.attack.match_type']
    Rails.logger.info("Rack_Attack: #{req.env['rack.attack.match_type']} #{req.ip} #{req.request_method} #{req.fullpath}")
  end
end
