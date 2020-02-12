# frozen_string_literal: true

require 'rails_helper'

describe Elplano::HealthChecks::Redis::QueuesCheck do
  include_examples 'simple_check', 'redis_queues_ping', 'RedisQueues', 'PONG'
end
