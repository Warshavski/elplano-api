# frozen_string_literal: true

FactoryBot.define do
  factory :activity_event, class: ActivityEvent do
    association :author, factory: :user

    action  { :created }
    details { { details: 'some additional details' } }

    trait :created do
      action { :created }
    end

    trait :updated do
      action { :updated }
    end
  end
end
