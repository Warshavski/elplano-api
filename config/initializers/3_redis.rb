#
# Make sure we initialize a Redis connection pool before multi-threaded execution starts by
#
#   1. Sidekiq
#   2. Rails.cache
#   3. Sessions
#
Elplano::Redis::Cache.with { nil }
Elplano::Redis::Queues.with { nil }
Elplano::Redis::Sessions.with { nil }
