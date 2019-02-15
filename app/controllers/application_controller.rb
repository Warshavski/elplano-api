# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include Responder
  include ExceptionHandler
  include JsonApi::RestifyParams

  DEFAULT_CACHE_CONTROL = "#{ActionDispatch::Http::Cache::Response::DEFAULT_CACHE_CONTROL}, no-store"

  before_action :destroy_session
  before_action :check_request_format
  before_action :set_page_title_header
  before_action :set_default_headers

  prepend_before_action :doorkeeper_authorize!

  def check_request_format
    route_not_found unless json_request?
  end

  def route_not_found
    if current_user
      not_found('endpoint does not exists')
    else
      doorkeeper_authorize!
    end
  end

  def json_request?
    request.format.json?
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
