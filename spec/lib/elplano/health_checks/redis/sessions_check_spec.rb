# frozen_string_literal: true

require 'rails_helper'

describe Elplano::HealthChecks::Redis::SessionsCheck do
  include_examples 'simple_check', 'redis_sessions_ping', 'RedisSessions', 'PONG'
end
