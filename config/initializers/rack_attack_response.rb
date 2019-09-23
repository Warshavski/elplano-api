# frozen_string_literal: true

Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]

  headers = {
    'Content-Type' => Mime[:json],
    'RateLimit-Limit' => match_data[:limit].to_s,
    'RateLimit-Remaining' => '0',
    'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
  }

  body = {
    errors: [
      {
        status: 429,
        detail: "#{I18n.t('errors.messages.throttled')}"
      }
    ]
  }

  [429, headers, [body.to_json]]
end
