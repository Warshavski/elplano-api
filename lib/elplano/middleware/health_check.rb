# frozen_string_literal: true

module Elplano
  module Middleware
    # Elplano::Middleware::HealthCheck
    #
    #   This middleware provides a health check that does not hit the database.
    #   Its purpose is to notify the prober that the application server is handling requests,
    #   but a 200 response does not signify that the database or other services are ready.
    #
    # NOTE : For more details see:
    #         - https://thisdata.com/blog/making-a-rails-health-check-that-doesnt-hit-the-database/
    #
    class HealthCheck
      #
      # This can't be frozen because Rails::Rack::Logger wraps the body
      #
      # rubocop:disable Style/MutableConstant
      OK_RESPONSE = [200, { 'Content-Type' => 'text/plain' }, ['Elplano OK']]
      EMPTY_RESPONSE = [404, { 'Content-Type' => 'text/plain' }, ['']]
      # rubocop:enable Style/MutableConstant

      HEALTH_PATH = '/-/health'

      def initialize(app)
        @app = app
      end

      def call(env)
        return @app.call(env) unless env['PATH_INFO'] == HEALTH_PATH

        request = Rack::Request.new(env)

        return OK_RESPONSE if client_ip_whitelisted?(request)

        EMPTY_RESPONSE
      end

      def client_ip_whitelisted?(request)
        ip_whitelist.any? { |e| e.include?(request.ip) }
      end

      def ip_whitelist
        @ip_whitelist ||= monitoring['ip_whitelist'].map(&IPAddr.method(:new))
      end

      def monitoring
        Elplano.config.monitoring
      end
    end
  end
end
