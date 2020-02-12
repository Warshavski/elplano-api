# frozen_string_literal: true

# RedisHelpers
#
#   Provides spec helpers for redis(cleanup)
#
module RedisHelpers
  #
  # Usage: performance enhancement
  #
  def redis_cache_cleanup!
    Elplano::Redis::Cache.with(&:flushall)
  end

  #
  # Usage: SideKiq
  #
  def redis_queues_cleanup!
    Elplano::Redis::Queues.with(&:flushall)
  end
end
