# frozen_string_literal: true

FactoryBot.define do
  factory :group, class: Group do
    number  { Faker::Number.number }
    title   { Faker::Lorem.sentence(3) }

    president

    trait :with_students do
      after(:build) do |group, _|
        group.students = create_list(:student, 5)
      end
    end
  end

  factory :group_params, class: Hash do
    initialize_with do
      {
        type: 'group',
        attributes: {
          title: Faker::Lorem.sentence(3),
          number: Faker::Number.number(5)
        }
      }
    end
  end

  factory :invalid_group_params, class: Hash do
    initialize_with do
      {
        type: 'group',
        attributes: {
          title: nil,
          number: nil
        }
      }
    end
  end
end
