require 'rails_helper'

describe Elplano::HealthChecks::Redis::CacheCheck do
  include_examples 'simple_check', 'redis_cache_ping', 'RedisCache', 'PONG'
end
