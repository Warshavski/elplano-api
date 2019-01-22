# frozen_string_literal: true

# AboutController
#
#   Used to represent core information about API
#
class AboutController < ApplicationController
  skip_before_action :doorkeeper_authorize!

  # GET : /
  #
  # Show version and revision
  #
  def show
    api_info = {
      version: Elplano.version,
      revision: Elplano.revision
    }

    render json: { data: api_info }, status: :ok
  end
end
