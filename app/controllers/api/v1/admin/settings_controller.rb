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
        specify_title_header 'Settings'

        # PATCH/PUT : api/v1/admin/settings
        #
        # Update application settings managed by admin
        #
        def update
          ::Admin::Settings::Manage.call(current_user, settings_params)

          render_meta message: I18n.t('generic.messages.saved')
        end

        private

        def settings_params
          params.require(:admin_settings).permit(*AdminSetting::ATTRIBUTES)
        end
      end
    end
  end
end
