# frozen_string_literal: true

module Errors
  # Errors::RequestErrorsSerializer
  #
  class RequestErrorsSerializer
    class << self
      attr_reader :resolvers

      def resolver(status, &block)
        (@resolvers ||= {})[status] = block
      end
    end

    resolver :kaboom do |_, opts|
      message = I18n.t('errors.messages.request.internal_server_error')

      { status: opts[:status_code], detail: message, source: { pointer: 'server' } }
    end

    resolver :missing_parameter do |error, opts|
      { status: opts[:status_code], detail: error.message, source: { pointer: error.param } }
    end

    resolver :not_found do |error, opts|
      model = error.model.downcase

      model_name  = I18n.t(error.model.downcase, scope: :'activerecord.models')
      message     = I18n.t('errors.messages.not_found_record', model: model_name, id: error.id)

      { status: opts[:status_code], detail: message, pointer: model }
    end

    resolver :invalid_record do |error, opts|
      RecordErrorsSerializer.new(error.record, opts[:status_code]).serialize
    end

    resolver :access_denied do |error, opts|
      message = error.result.message

      { status: opts[:status_code], detail: message, source: { pointer: 'authorization scope' } }
    end

    resolver :timeout do |_, opts|
      message = I18n.t('errors.messages.request.request_timeout')

      { status: opts[:status_code], detail: message, source: { pointer: 'server' } }
    end

    resolver :validation do |error, opts|
      ::Validatable::Serializer.new(error, opts[:status_code]).serialize
    end

    resolver :missing_file do |error, opts|
      { status: opts[:status_code], detail: error.message, source: opts[:pointer] }
    end

    resolver :unauthorized do |error, opts|
      { status: opts[:status_code], detail: error.message, source: { pointer: "/attributes/#{error.param}" } }
    end

    def initialize(error, type)
      @error = error
      @type = type
    end

    def serialize(status, opts = {})
      status_code = Rack::Utils.status_code(status)
      resolver    = self.class.resolvers[@type]

      error_description =
        resolver.call(@error, opts.merge(status_code: status_code))

      Oj.dump(errors: Array.wrap(error_description))
    end
  end
end
