# frozen_string_literal: true

FactoryBot.define do
  factory :assignment, class: Assignment do
    student
    task

    extra_links { [{ service: 'Google', url: Faker::Internet.url }] }

    accomplished { false }

    trait :accomplished do
      accomplished { true }
    end

    trait :unfulfilled do
      accomplished { false }
    end
  end
end
