# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include Handlers::Exception
  include Handlers::Response

  include JsonApi::DoorkeeperConcern

  include Authorizable
  include Denotable
  include Localizable
  include Validatable

  DEFAULT_CACHE_CONTROL = "#{ActionDispatch::Http::Cache::Response::DEFAULT_CACHE_CONTROL}, no-store"

  before_action :destroy_session
  before_action :check_request_format

  before_action :configure_default_headers
  before_action :configure_permitted_parameters, if: :devise_controller?

  prepend_before_action :authorize_access!

  around_action :configure_timezone, if: :current_user

  specify_title_header 'El Plano'

  authorize :user, through: :current_user
  authorize :student, through: :current_student

  def check_request_format
    head :unsupported_media_type unless json_request?
  end

  def route_not_found
    if user_signed_in?
      not_found(I18n.t(:'errors.messages.not_found_endpoint'))
    else
      authorize_access!
    end
  end

  def not_found(message = I18n.t(:'errors.messages.not_found_record'))
    render_error([{ status: 404, detail: message }], :not_found)
  end

  def json_request?
    request.format.json? && json_content_type?
  end

  def json_content_type?
    request.content_type == Mime[:json]
  end

  def configure_default_headers
    headers['X-Frame-Options'] = 'DENY'
    headers['X-XSS-Protection'] = '1; mode=block'
    headers['X-Content-Type-Options'] = 'nosniff'

    if user_signed_in?
      #
      # Adds `no-store` to the DEFAULT_CACHE_CONTROL,
      # to prevent security concerns due to caching private data.
      #
      headers['Cache-Control'] = DEFAULT_CACHE_CONTROL
      headers['Pragma'] = 'no-cache' # HTTP 1.0 compatibility
    end
  end

  def authorize_access!
    auth = doorkeeper_authorize!

    return unless auth.nil?

    options = { event: :fetch, token: doorkeeper_token }

    warden.set_user(current_user, options).then do |user|
      authorize! user, with: UserPolicy
    end
  end

  def authorize_action!(entity)
    authorize! entity

    yield(entity) if block_given?
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email username])
  end

  def configure_timezone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def destroy_session
    request.session_options[:skip] = true
  end

  # Optional filter parameters :
  #
  #   - search - filter by given term(pattern)
  #
  #   - pagination
  #       - last_id       - Identity of the last record in previous chunk
  #       - limit         - Quantity of the records in requested chuck
  #       - direction     - Records sort direction(asc - ascending, desc - descending)
  #       - field         - Name of the sortable field
  #       - field_value   - Value of the sortable field
  #       - page          - Page number
  #
  #   @example:
  #     {
  #       "filters": {
  #         "last_id": 15,
  #         "limit": 10,
  #         "direction": "desc",
  #         "field_name": "email",
  #         "field_value": "wat@email.huh",
  #         "search": "search term"
  #         "page": 2
  #       }
  #     }
  #
  def filter_params(contract = FilterContract)
    # Try to parse filter params and in case of error just ignore them
    filters = begin
                params[:filters].blank? ? {} : JSON.parse(params[:filters])
              rescue StandardError
                {}
              end

    validate_with(contract.new, filters)
  end

  def current_resource_owner
    return nil unless doorkeeper_token

    @current_resource_owner ||= User
                                .eager_load(:student)
                                .find(doorkeeper_token.resource_owner_id)
  end

  alias current_user current_resource_owner

  def current_student
    @current_student ||= current_user&.student
  end

  def current_group
    @current_group ||= current_student&.group
  end

  def supervised_group
    @supervised_group ||= current_student&.supervised_group
  end

  def user_signed_in?
    !current_user.nil?
  end
end
