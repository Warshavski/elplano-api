# frozen_string_literal: true

module Api
  # Api::UnprocessableAuth
  #
  #   Raised when a any
  #
  class UnprocessableAuth < StandardError
    attr_reader :param

    def initialize(param)
      super(I18n.t(:'errors.messages.unprocessable_auth', param: param)).tap { @param = param }
    end
  end
end
