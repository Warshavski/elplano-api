# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Task do
    title  { Faker::Lorem.sentence(word_count: 2) }

    author
    event

    trait :skip_validation do
      to_create { |instance| instance.save(validate: false) }
    end

    trait :accomplished do
      after(:create) do |task, _|
        create(:assignment, :accomplished, student: task.author, task: task)
      end
    end
  end

  factory :task_params, class: Hash do
    initialize_with do
      {
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.sentences(number: 3),
        expired_at: Time.current + 1.day
      }
    end
  end

  factory :invalid_task_params, class: Hash do
    initialize_with do
      {
        title: nil
      }
    end
  end
end
