# frozen_string_literal: true

require 'rails_helper'

describe Elplano::HealthChecks::RedisCheck do
  include_examples 'simple_check', 'redis_ping', 'Redis', 'PONG'
end
