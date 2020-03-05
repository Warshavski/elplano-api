# frozen_string_literal: true

FactoryBot.define do
  factory :active_token, class: ActiveToken do
    token { Faker::Internet.device_token }

    ip_address  { Faker::Internet.ip_v4_address }
    browser     { 'Chrome' }
    os          { 'Windows' }

    device_name { Faker::Device.model_name }
    device_type { Faker::Device.platform }

    created_at { Faker::Date.backward }
    updated_at { Faker::Date.backward}
  end
end
