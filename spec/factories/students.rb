# frozen_string_literal: true

FactoryBot.define do
  factory :student, class: Student, aliases: [:creator] do
    full_name { Faker::Name.name_with_middle }
    email     { Faker::Internet.email }
    phone     { Faker::PhoneNumber.cell_phone }
    about     { Faker::Lorem.paragraph(5) }

    social_networks do
      {
        'twitter' => Faker::Internet.url('twitter'),
        'facebook' => Faker::Internet.url('facebook')
      }
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
            'twitter' => 'https://twitter.com/watever',
            'facebook' => 'https://facebook.com/watever'
          }
        }
      }
    end
  end
end
