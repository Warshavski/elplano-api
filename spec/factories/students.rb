# frozen_string_literal: true

FactoryBot.define do
  factory :student, class: Student, aliases: [:creator] do

    full_name { Faker::Name.name_with_middle }
    email     { Faker::Internet.email }
    phone     { Faker::PhoneNumber.cell_phone }

    user

    trait :president do
      president { true }
    end

    factory :president, traits: [:president]
  end

  factory :student_params, class: Hash do
    initialize_with do
      {
        type: 'student',
        attributes: {
          email: 'wat@wat.wat',
          phone: '+8 983 47 89 312',
          full_name: 'Sir Wat Name Yeah',
          social_networks: {
            'facebook' => 'some facebook link',
            'twitter' => 'some twitter link'
          }
        }
      }
    end
  end
end
