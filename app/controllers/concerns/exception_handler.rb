# frozen_string_literal: true

# ExceptionHandler
#
#   Used to handle ActiveRecord exceptions
#
module ExceptionHandler
  extend ActiveSupport::Concern

  included do

    # Return 400 - Bad Request
    #
    rescue_from ActionController::ParameterMissing do |e|
      log_exception(e)

      render_errors([{ status: 400, detail: e.message, source: { pointer: e.param }}], :bad_request)
    end

    # Return 404 - Not Found
    #
    rescue_from ActiveRecord::RecordNotFound do |e|
      log_exception(e)

      not_found(e.message)
    end

    # Return 422 - Unprocessable Entity (validation|duplicate record)
    #
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique do |e|
      log_exception(e)

      render_errors(ErrorSerializer.serialize(e.record, 422), :unprocessable_entity)
    end

    rescue_from Errors::AuthError do |e|
      log_exception(e)

      render_errors(
        [
          {
            status: 403,
            detail: e.message,
            source: { pointer: 'authorization header' }
          }
        ],
        :forbidden
      )
    end

    def not_found(message = 'Record not found')
      render_errors([{ status: 404, detail: message }], :not_found)
    end

    private

    def render_errors(object, status)
      render json: { errors: object }, status: status
    end

    def log_exception(exception)
      application_trace = ActionDispatch::ExceptionWrapper
                          .new(ActiveSupport::BacktraceCleaner.new, exception)
                          .application_trace

      application_trace.map! { |t| "  #{t}\n" }

      logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
    end
  end
end
