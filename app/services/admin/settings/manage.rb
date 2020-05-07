# frozen_string_literal: true

module Admin
  module Settings
    # Admin::Settings::Manage
    #
    #   Used to manage application settings via admin panel
    #
    class Manage
      include Loggable

      # see #execute
      def self.call(current_user, settings_params)
        new.execute(current_user, settings_params)
      end

      # Perform application settings update
      #
      # @param current_user [User] -
      #   User, who performs settings update(admin user)
      #
      # @param settings_params [Hash]  -
      #   Application setting params(attributes)
      #
      # @option params [String] :app_contact_username -
      #   Username you can contact for questions related to the application
      #
      # @option params [String] :app_contact_email -
      #   Email you can use to contact for questions related to the application
      #
      # @option params [String] :app_title -
      #   Application title(name)
      #
      # @option params [String] :app_short_description -
      #   Short application description
      #
      # @option params [String] :app_description -
      #   Full application description
      #
      # @option params [String] :app_extended_description -
      #   Extended application description(may contains markdown)
      #
      # @option params [String] :app_terms -
      #   Application legal information
      #
      # @return [AdminSetting]
      # @raise [ActiveRecord::RecordInvalid]
      #
      def execute(current_user, settings_params)
        settings = AdminSetting.new(settings_params)

        raise ActiveRecord::RecordInvalid, settings unless settings.save

        message =
          "Setting was updated with params: \"#{settings_params}\" " \
          "by \"#{current_user.username}\" (#{current_user.email})"

        settings.tap { log_info(message) }
      end
    end
  end
end
