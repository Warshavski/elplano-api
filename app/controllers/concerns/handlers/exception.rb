# frozen_string_literal: true

module Handlers
  # Handlers::Exception
  #
  #   Used to handle application exceptions and render appropriate json response
  #
  module Exception
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      # Return 500 - Internal Server Error
      #
      rescue_from StandardError do |e|
        handle_error(e, :internal_server_error, send_report: true) do
          message = I18n.t('errors.messages.request.internal_server_error')

          [{ status: 500, detail: message, source: { pointer: 'server' } }]
        end
      end

      # Return 400 - Bad Request
      #
      rescue_from ActionController::ParameterMissing do |e|
        handle_error(e, :bad_request) do
          [{ status: 400, detail: e.message, source: { pointer: e.param } }]
        end
      end

      # Return 404 - Not Found
      #
      rescue_from ActiveRecord::RecordNotFound do |e|
        handle_error(e, :not_found) do
          options = {
            model: I18n.t(e.model.downcase, scope: :'activerecord.models'),
            id: e.id
          }

          [{ status: 404, detail: I18n.t('errors.messages.not_found_record', options) }]
        end
      end

      # Return 422 - Unprocessable Entity (validation|duplicate record)
      #
      rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique do |e|
        handle_error(e, :unprocessable_entity) do
          ErrorSerializer.new(e.record).serialize
        end
      end

      # Return 403 - Forbidden (No access rights)
      #
      rescue_from ActionPolicy::Unauthorized do |e|
        handle_error(e, :forbidden) do
          [{ status: 403, detail: e.result.message, source: { pointer: 'authorization scope' } }]
        end
      end

      # Return 408 - Request Timeout
      #
      rescue_from Rack::Timeout::RequestTimeoutException do |e|
        handle_error(e, :request_timeout, send_report: true) do
          message = I18n.t('errors.messages.request.request_timeout')

          [{ status: 408, detail: message, source: { pointer: 'server' } }]
        end
      end
    end

    private

    def handle_error(error, status, send_report: false)
      log_exception(error, send_report: send_report)

      render_error(yield, status)
    end

    def render_error(representation, status)
      render json: { errors: representation }, status: status
    end

    def log_exception(exception, send_report: false)
      application_trace = ActionDispatch::ExceptionWrapper
                          .new(ActiveSupport::BacktraceCleaner.new, exception)
                          .application_trace

      application_trace.map! { |t| "  #{t}\n" }

      logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"

      Rollbar.error(exception) if send_report
    end
  end
end
