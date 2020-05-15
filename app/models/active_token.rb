# frozen_string_literal: true

# ActiveToken
#
#   Used to store user's active access tokens
#
class ActiveToken
  include ActiveModel::Model

  ACTIVE_TOKENS_LIMIT = 100

  attr_accessor :token, :created_at, :updated_at,
                :ip_address, :browser, :os,
                :device_name, :device_type

  class << self
    def set(user, token, request)
      storage.with do |redis|
        active_token = new(compose_session_info(token, request, user))

        redis.pipelined do
          key = key_name(user.id, token)
          redis.setex(key, expiration, Marshal.dump(active_token))

          lookup_key = lookup_key_name(user.id)
          redis.sadd(lookup_key, token)
        end
      end
    end

    def list(user)
      storage.with do |redis|
        # TODO : exchange with message pack
        cleaned_up_lookup_entries(redis, user).map { |entry| Marshal.load(entry) } # rubocop:disable Security/MarshalLoad
      end
    end

    def cleanup(user)
      storage.with do |redis|
        clean_up_old_sessions(redis, user)
        cleaned_up_lookup_entries(redis, user)
      end
    end

    def destroy(user, token)
      storage.with { |redis| destroy_tokens(redis, user, [token]) }
    end

    private

    def storage
      Elplano::Redis::Sessions
    end

    def expiration
      Doorkeeper.configuration.access_token_expires_in.seconds.to_i
    end

    def key_name(user_id, token = '*')
      "#{storage.namespace}:#{user_id}:#{token}"
    end

    def lookup_key_name(user_id)
      "#{storage.lookup_namespaces(:user_sessions)}:#{user_id}"
    end

    def compose_session_info(token, request, user) # rubocop:disable Metrics/MethodLength
      client    = DeviceDetector.new(request.user_agent)
      timestamp = Time.current

      {
        ip_address: request.ip,
        browser: client.name,
        os: client.os_name,
        device_name: client.device_name,
        device_type: client.device_type,
        created_at: user.current_sign_in_at || timestamp,
        updated_at: timestamp,
        token: token
      }
    end

    def cleaned_up_lookup_entries(redis, user)
      token_collection = token_collection_for_user(user.id)
      entries = raw_active_token_entries(redis, token_collection, user.id)

      #
      # Remove expired keys.
      #
      # Only the single key entries are automatically expired by redis,
      # the lookup entries in the set need to be removed manually.
      #
      tokens_and_entries = token_collection.zip(entries)

      redis.pipelined do
        tokens_and_entries
          .reject { |_token, entry| entry }
          .each { |token, _entry| redis.srem(lookup_key_name(user.id), token) }
      end

      entries.compact
    end

    def clean_up_old_sessions(redis, user)
      token_collection = token_collection_for_user(user.id)

      return if token_collection.count <= ACTIVE_TOKENS_LIMIT

      #
      # remove token if there are more than ACTIVE_TOKENS_LIMIT.
      #
      token_entities =
        active_token_entries(token_collection, user.id, redis).sort_by!(&:updated_at).reverse!

      destroyable_entities  = token_entities.drop(ACTIVE_TOKENS_LIMIT)
      destroyable_ids       = destroyable_entities.map { |entity| entity.public_send :token }

      destroy_tokens(redis, user, destroyable_ids) if destroyable_ids.any?
    end

    def destroy_tokens(redis, user, token_collection)
      key_names   = token_collection.map { |token| key_name(user.id, token) }
      token_names = token_collection.map { |token| "#{storage.namespace}:#{token}" }

      redis.srem(lookup_key_name(user.id), token_collection)
      redis.del(key_names)
      redis.del(token_names)
    end

    def active_token_entries(token_collection, user_id, redis)
      return [] if token_collection.empty?

      entry_keys = raw_active_token_entries(redis, token_collection, user_id)

      entry_keys.compact.map { |raw| Marshal.load(raw) } # rubocop:disable Security/MarshalLoad
    end

    def token_collection_for_user(user_id)
      storage.with { |redis| redis.smembers(lookup_key_name(user_id)) }
    end

    def raw_active_token_entries(redis, token_collection, user_id)
      return [] if token_collection.empty?

      token_collection
        .map { |token| key_name(user_id, token) }
        .then { |entry_keys| redis.mget(entry_keys) }
    end
  end
end
