# frozen_string_literal: true

module JsonApi
  # JsonApi::DeviseConcern
  #
  #   Provides some JSON:API compatibility for Devise controllers
  #
  module DeviseConcern
    extend ActiveSupport::Concern

    included do
      specify_serializers default: UserSerializer

      protected

      def process_error(resource)
        yield if block_given?

        render_error(ErrorSerializer.new(resource).serialize, :unprocessable_entity)
      end

      # Helper for use after calling send_*_instructions methods on a resource.
      #
      # NOTE : If we are in paranoid mode, we always act as if the resource was valid and instructions were sent.
      #
      def successfully_sent?(resource)
        message_kind = resolve_message_kind!(resource)

        return false if message_kind.nil?

        @message = find_message(message_kind, {})
        true
      end

      def resolve_message_kind!(resource)
        if Devise.paranoid
          resource.errors.clear
          :send_paranoid_instructions
        elsif resource.errors.empty?
          :send_instructions
        end
      end
    end
  end
end
