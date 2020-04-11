# frozen_string_literal: true

FactoryBot.define do
  factory :student, class: Student, aliases: %i[creator author] do
    full_name { Faker::Name.name_with_middle }
    email     { Faker::Internet.email }
    phone     { Faker::PhoneNumber.cell_phone }
    about     { Faker::Lorem.paragraph(sentence_count: 5) }

    birthday  { Faker::Date.birthday }
    gender    { Faker::Gender.binary_type.downcase }

    social_networks do
      [
        {
          network: 'twitter',
          url: Faker::Internet.url(host: 'twitter')
        },
        {
          network: 'facebook',
          url: Faker::Internet.url(host: 'facebook')
        }
      ]
    end

    user

    trait :president do
      president { true }
    end

    trait :group_member do
      after(:build) do |student, _|
        student.group = create(:group)
      end
    end

    trait :group_supervisor do
      after(:create) do |student, _|
        student.supervised_group = create(:group, president: student, students: [student])
      end
    end

    factory :president, traits: [:president]
    factory :group_supervisor, traits: [:group_supervisor]
  end

  factory :student_params, class: Hash do
    initialize_with do
      {
        email: 'wat@wat.wat',
        phone: '+8 983 47 89 312',
        full_name: 'Sir Wat Name Yeah',
        social_networks: [
          {
            network: 'twitter',
            url: Faker::Internet.url(host: 'twitter')
          },
          {
            network: 'facebook',
            url: Faker::Internet.url(host: 'facebook')
          }
        ]
      }
    end
  end

  factory :invalid_student_params, class: Hash do
    initialize_with do
      {
        email: nil,
        phone: nil,
        full_name: nil,
        social_networks: nil
      }
    end
  end
end
