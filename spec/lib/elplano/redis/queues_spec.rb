require 'rails_helper'

RSpec.describe Elplano::Redis::Queues do
  let(:config_file_name) { 'config/redis.queues.yml' }
  let(:environment_config_file_name) { 'ELPLANO_REDIS_QUEUES_CONFIG_FILE' }
  let(:redis_port) { 6381 }
  let(:redis_database) { 11 }
  let(:sentinel_port) { redis_port + 20000 }
  let(:config_env_variable_url) { 'ELPLANO_GITLAB_REDIS_QUEUES_URL' }
  let(:class_redis_url) { Elplano::Redis::Queues::DEFAULT_REDIS_QUEUES_URL }

  include_examples 'redis_shared_examples'
end
