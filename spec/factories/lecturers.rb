# frozen_string_literal: true

FactoryBot.define do
  factory :lecturer, class: Lecturer do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    patronymic  { Faker::Name.suffix }

    active { true }

    group

    trait :with_courses do
      after(:create) do |lecturer, _|
        lecturer.update!(courses: create_list(:course, 1, group: lecturer.group))
      end
    end
  end

  factory :lecturer_params, class: Hash do
    initialize_with do
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        patronymic: Faker::Name.prefix,
        phone: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email,
        active: true
      }
    end
  end

  factory :invalid_lecturer_params, class: Hash do
    initialize_with do
      {
        first_name: nil,
        last_name: '',
        patronymic: Faker::Lorem.sentence(20),
        email: 'wat.email'
      }
    end
  end
end
