require 'rails_helper'

module RestifyHelper
  def parametrize(hash)
    ActionController::Parameters.new(hash).permit!
  end
end
