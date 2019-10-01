# frozen_string_literal: true

FactoryBot.define do
  factory :assignment, class: Assignment do
    title  { Faker::Lorem.sentence(word_count: 2) }

    author
    course

    trait :skip_validation do
      to_create { |instance| instance.save(validate: false) }
    end
  end

  factory :assignment_params, class: Hash do
    initialize_with do
      {
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.sentences(number: 3),
        expired_at: Time.current + 1.day
      }
    end
  end

  factory :invalid_assignment_params, class: Hash do
    initialize_with do
      {
        title: nil
      }
    end
  end
end
