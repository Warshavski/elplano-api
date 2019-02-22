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
    information = {
      version: Elplano.version,
      revision: Elplano.revision
    }

    render json: { meta: information }, status: :ok
  end
end
