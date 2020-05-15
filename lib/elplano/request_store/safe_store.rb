# frozen_string_literal: true

module Elplano
  module RequestStore
    # Elplano::RequestStore::SafeStore
    #
    #   [DESCRIPTION]
    #
    module SafeStore
      NULL_STORE = Elplano::RequestStore::NullStore.new

      class << self
        # These methods should always run directly against RequestStore
        delegate :clear!, :begin!, :end!, :active?, to: :RequestStore

        # These methods will run against NullRequestStore if RequestStore is disabled
        delegate :read, :[], :write, :[]=, :exist?, :fetch, :delete, to: :store

        def store
          ::RequestStore.active? ? ::RequestStore : NULL_STORE
        end

        #
        # This method accept an options hash to be compatible with
        # ActiveSupport::Cache::Store#write method. The options are
        # not passed to the underlying cache implementation because
        # RequestStore#write accepts only a key, and value params.
        #
        def write(key, value, _options = nil)
          store.write(key, value)
        end
      end
    end
  end
end
