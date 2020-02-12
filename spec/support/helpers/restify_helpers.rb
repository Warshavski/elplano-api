# frozen_string_literal: true

require 'rails_helper'

# RestifyHelpers
#
#   Provides spec helper methods for restify module
#
module RestifyHelpers
  def parametrize(hash)
    ActionController::Parameters.new(hash).permit!
  end
end
