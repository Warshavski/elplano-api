# frozen_string_literal: true

FactoryBot.define do
  factory :assignment, class: Assignment do
    student
    task

    accomplished { false }

    trait :accomplished do
      accomplished { true }
    end

    trait :unfulfilled do
      accomplished { false }
    end
  end
end
