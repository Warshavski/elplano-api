# frozen_string_literal: true

# ExceptionHandler
#
#   Used to handle application exceptions and render appropriate json response
#
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # Return 500 - Internal Server Error
    #
    rescue_from StandardError do |e|
      handle_error(e, :internal_server_error) do
        [{ status: 500, detail: '(ノಠ益ಠ)ノ彡┻━┻', source: { pointer: 'server' } }]
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
        [{ status: 404, detail: e.message }]
      end
    end

    # Return 422 - Unprocessable Entity (validation|duplicate record)
    #
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique do |e|
      handle_error(e, :unprocessable_entity) do
        ErrorSerializer.serialize(e.record, 422)
      end
    end

    rescue_from Elplano::Errors::AuthError do |e|
      handle_error(e, :forbidden) do
        [{ status: 403, detail: e.message, source: { pointer: 'authorization header' } }]
      end
    end
  end

  private

  def handle_error(error, status)
    log_exception(error)

    render_error(yield, status)
  end

  def render_error(representation, status)
    render json: { errors: representation }, status: status
  end

  def log_exception(exception)
    application_trace = ActionDispatch::ExceptionWrapper
                        .new(ActiveSupport::BacktraceCleaner.new, exception)
                        .application_trace

    application_trace.map! { |t| "  #{t}\n" }

    logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
  end
end
