# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::ApplicationController
      #
      #   Basic controller for the admin section
      #     (common logic across all of the admin controllers)
      #
      class ApplicationController < ::ApplicationController
        authorize_with! ::Admin::UserPolicy
      end
    end
  end
end
