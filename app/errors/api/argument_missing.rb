# frozen_string_literal: true

module Api
  # Api::ArgumentMissing
  #
  #   Raised when a required argument is missing.
  #
  class ArgumentMissing < StandardError
    attr_reader :param

    def initialize(param)
      super(I18n.t(:'errors.messages.argument_missing', param: param)).tap { @param = param }
    end
  end
end
