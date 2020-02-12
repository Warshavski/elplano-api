# frozen_string_literal: true

require 'rails_helper'

describe Elplano::Redis::Cache do
  let(:class_redis_url) { Elplano::Redis::Cache::DEFAULT_REDIS_CACHE_URL }

  include_examples 'redis_shared_examples'
end
