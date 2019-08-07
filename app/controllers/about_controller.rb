# frozen_string_literal: true

# AboutController
#
#   Used to represent core information about API
#
class AboutController < ApplicationController
  skip_before_action :authorize_access!

  # GET : /
  #
  # Show app information
  #   (version, description, e.t.c.)
  #
  def show
    render_meta ::Information::Compose.call
  end
end
