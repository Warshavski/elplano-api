VkontakteApi.configure do |config|
  config.app_id       = ENV['VK_CLIENT_ID']
  config.app_secret   = ENV['VK_CLIENT_SECRET']
  config.api_version  = ENV['VK_API_VERSION']

  config.logger        = Rails.logger
  config.log_requests  = true
  config.log_errors    = true
  config.log_responses = false
end
