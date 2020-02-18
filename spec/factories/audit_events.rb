# frozen_string_literal: true

FactoryBot.define do
  factory :audit_event, class: AuditEvent do
    association :author, factory: :user
    association :entity, factory: :user

    audit_type  { :authentication }
    details     { { with: :google } }

    trait :authentication do
      audit_type { :authentication }
    end

    trait :permanent_action do
      audit_type { :permanent_action }
    end
  end
end
