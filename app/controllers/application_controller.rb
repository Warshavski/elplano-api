# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include ActionPolicy::Controller

  include ParamsRequirable

  include Handlers::Exception
  include Handlers::Response

  include DoorkeeperJsonApi

  DEFAULT_CACHE_CONTROL = "#{ActionDispatch::Http::Cache::Response::DEFAULT_CACHE_CONTROL}, no-store"

  before_action :destroy_session
  before_action :check_request_format
  before_action :set_page_title_header
  before_action :set_default_headers

  prepend_before_action :authorize_access!

  authorize :user, through: :current_user
  authorize :student, through: :current_student

  def check_request_format
    head :unsupported_media_type unless json_request?
  end

  def route_not_found
    if current_user
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

  def set_default_headers
    headers['X-Frame-Options'] = 'DENY'
    headers['X-XSS-Protection'] = '1; mode=block'
    headers['X-Content-Type-Options'] = 'nosniff'

    if current_user
      #
      # Adds `no-store` to the DEFAULT_CACHE_CONTROL,
      # to prevent security concerns due to caching private data.
      #
      headers['Cache-Control'] = DEFAULT_CACHE_CONTROL
      headers['Pragma'] = 'no-cache' # HTTP 1.0 compatibility
    end
  end

  def set_page_title_header
    #
    # Per https://tools.ietf.org/html/rfc5987, headers need to be ISO-8859-1, not UTF-8
    #
    response.headers['Page-Title'] = CGI.escape(page_title('El Plano'))
  end

  def page_title(*titles)
    @page_title ||= []

    @page_title.push(*titles.compact) if titles.any?

    if titles.any? && !defined?(@breadcrumb_title)
      @breadcrumb_title = @page_title.last
    end

    # Segments are separated by middot
    @page_title.join(' · ')
  end

  def authorize_access!
    #
    # This means that doorkeeper authorization was successful
    #  otherwise, doorkeeper would render an error
    #
    if doorkeeper_authorize!.nil?
      authorize!(current_user)
    end
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end

  def current_resource_owner
    return nil unless doorkeeper_token

    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
  end

  alias current_user current_resource_owner

  def current_student
    @current_student ||= current_user.student
  end

  def current_group
    @current_group ||= current_student.group
  end

  def supervised_group
    @supervised_group ||= current_student.supervised_group
  end
end
