# frozen_string_literal: true

module Handlers
  # Handlers::Response
  #
  #   Used to represent the requested data using a serializer
  #
  module Response
    extend ActiveSupport::Concern

    included do
      def self.set_default_serializer(serializer)
        @default_serializer = serializer
      end

      def self.default_serializer
        @default_serializer
      end

      def render_resource(resource, options = {})
        serializer, status = process_render_options(options)
        serializer_options = process_serializer_options(options)

        data = serializer
               .new(resource, serializer_options)
               .serialized_json

        render json: data, status: status
      end

      def render_meta(data, status: :ok)
        render json: { meta: data }, status: status
      end

      private

      def process_serializer_options(options)
        options_keys = %i[fields meta links is_collection params include]

        options_keys.each_with_object({}) { |key, hash| hash[key] = options[key] }
      end

      def process_render_options(options)
        serializer = options[:serializer] || self.class.default_serializer
        status = options[:status] || :ok

        [serializer, status]
      end
    end
  end
end
