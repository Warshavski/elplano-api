include ActionDispatch::TestProcess

FactoryBot.define do
  factory :user, class: User do
    email     { Faker::Internet.email }
    username  { Faker::Internet.username }
    password  { '12345678' }

    confirmed_at        { Time.now }
    confirmation_token  { nil }

    locked_at     { nil }
    unlock_token  { nil }

    trait :admin do
      admin { true }
    end

    trait :banned do
      after(:build) { |user, _| user.update!(banned_at: Time.now) }
    end

    factory :admin, traits: [:admin]
  end
end
