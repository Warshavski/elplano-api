# frozen_string_literal: true

# Authorizable
#
#   Provides macro to set controller authorization scenarios
#
module Authorizable
  extend ActiveSupport::Concern
  include ActionPolicy::Controller

  class_methods do
    def authorize_with!(policy, **options)
      before_action(**options) { authorize! self, with: policy }
    end
  end
end
