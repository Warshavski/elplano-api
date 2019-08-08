# frozen_string_literal: true

FactoryBot.define do
  factory :admin_setting_params, class: Hash do
    initialize_with do
      {
        type: 'admin_settings',
        attributes: {
          app_contact_username: 'username',
          app_contact_email: 'user@email.example',
          app_title: 'Application title',
          app_short_description: '<b>Application short description</b>',
          app_description: '<b>Application description</b>',
          app_extended_description: '<b>Application extended description</b>',
          app_terms: '<b>Application terms of use</b>'
        }
      }
    end
  end
end
