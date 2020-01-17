# frozen_string_literal: true

module Handlers
  # Handlers::Response
  #
  #   Used to represent the requested data using a serializer
  #
  module Response
    extend ActiveSupport::Concern

    included do
      class << self
        attr_reader :default_serializer

        def set_default_serializer(serializer)
          @default_serializer = serializer
        end
      end

      def render_collection(collection, options = {})
        render_resource(collection, pagination_meta(collection).merge!(options))
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

      # NOTE : for the first time generate eta only for page-based pagination
      def pagination_meta(resources)
        return {} if filter_params[:page].blank?

        ::Pagination::Meta.new(request, resources, filter_params).call
      end

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
