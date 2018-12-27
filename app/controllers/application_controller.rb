# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include Responder
  include ExceptionHandler
  include JsonApi::RestifyParams

  before_action :check_request_format
  before_action :set_page_title_header

  def check_request_format
    route_not_found unless json_request?
  end

  def route_not_found
    if current_user
      not_found('endpoint does not exists')
    else
      authenticate_user!
    end
  end

  def json_request?
    request.format.json?
  end

  def set_page_title_header
    #
    # Per https://tools.ietf.org/html/rfc5987, headers need to be ISO-8859-1, not UTF-8
    #
    response.headers['Page-Title'] = CGI.escape(page_title('Stdplan'))
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
end
