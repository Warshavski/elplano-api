# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::SettingsController
      #
      #   Application settings management
      #     (admin configurable application settings)
      #
      class SettingsController < Admin::ApplicationController
        denote_title_header 'Settings'

        # PATCH/PUT : api/v1/admin/settings
        #
        # Update application settings managed by admin
        #
        def update
          settings = AdminSetting.new(settings_params)

          settings.save ? process_success : process_error(settings)
        end

        private

        def process_error(resource)
          render_error(ErrorSerializer.new(resource).serialize, :unprocessable_entity)
        end

        def process_success
          render_meta message: I18n.t('generic.messages.saved')
        end

        def settings_params
          params.require(:admin_settings).permit(*AdminSetting::ATTRIBUTES)
        end
      end
    end
  end
end
