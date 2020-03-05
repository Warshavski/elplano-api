# frozen_string_literal: true

module Api
  module V1
    module Activity
      # Api::V1::Activity::TokensController
      #
      #   Used to manage authenticated user's access tokens
      #
      class TokensController < ApplicationController
        denote_title_header 'Activity', 'Tokens'

        set_default_serializer ActiveTokenSerializer

        # GET : api/v1/activity/tokens
        #
        # Get list of authenticate user active access tokens
        #
        def index
          render_collection ActiveToken.list(current_user), status: :ok
        end
      end
    end
  end
end
