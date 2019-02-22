# frozen_string_literal: true

module Elplano
  module Errors
    # Elplano::Errors::ArgumentMissing
    #
    #   Raised when a required argument is missing.
    #
    class ArgumentMissing < StandardError
      attr_reader :param

      def initialize(param)
        @param = param
        super("argument is missing or the value is empty: #{param}")
      end
    end
  end
end
