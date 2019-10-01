# frozen_string_literal: true

FactoryBot.define do
  factory :course, class: Course do
    title  { Faker::Lorem.sentence(word_count: 2) }

    active { true }

    group

    trait :with_lecturers do
      after(:create) do |course, _|
        course.update!(lecturers: create_list(:lecturer, 1, group: course.group))
      end
    end
  end

  factory :course_params, class: Hash do
    initialize_with do
      {
        title: Faker::Educator.course,
        active: true
      }
    end
  end

  factory :invalid_course_params, class: Hash do
    initialize_with do
      {
        title: nil
      }
    end
  end
end
