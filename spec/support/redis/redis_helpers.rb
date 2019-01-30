module RedisHelpers
  #
  # Usage: performance enhancement
  #
  def redis_cache_cleanup!
    Elplano::Redis::Cache.with(&:flushall)
  end
end
