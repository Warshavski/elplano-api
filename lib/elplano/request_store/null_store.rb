# frozen_string_literal: true

module Elplano
  module RequestStore
    # Elplano::RequestStore::NullStore
    #
    #   [DESCRIPTION] # Used by Elplano::RequestStore::SafeStore
    #
    # NOTE : The methods `begin!`, `clear!`, and `end!` are not defined because they
    #         should only be called directly on `RequestStore`.
    #
    class NullStore
      def store
        {}
      end

      def active?; end

      def read(key); end

      def [](key); end

      def write(_key, value)
        value
      end

      def []=(_key, value)
        value
      end

      def exist?(_key)
        false
      end

      def fetch(_key)
        yield
      end

      def delete(key)
        yield(key) if block_given?
      end
    end
  end
end
