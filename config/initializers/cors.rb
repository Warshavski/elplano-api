# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.
#
# Read more: https://github.com/cyu/rack-cors
#
# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'example.com'
#
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end
#
# NOTE : Be sure to restart your server when you modify this file.
#
# Allow access to El Plano API from other domains
#
Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  #
  # Cross-origin requests must not have the session cookie available
  #
  allow do
    origins '*'
    resource '*',
             credentials: false,
             headers: :any,
             methods: :any,
             expose: %w[Link X-Total X-Total-Pages X-Per-Page X-Page X-Next-Page X-Prev-Page]
  end
end
