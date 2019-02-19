# frozen_string_literal: true

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

    trait :student do
      after(:create) { |user, _| create(:student, user: user) }
    end

    trait :reset_password do
      after(:build) do |user, _|
        user.reset_password_token = Devise.token_generator.digest(user, :reset_password_token, 'token')
        user.reset_password_sent_at = Time.now
      end
    end
  end

  factory :user_params, class: Hash do
    initialize_with do
      {
        type: 'user',
        attributes: {
          email: 'wat@wat.wat',
          email_confirmation: 'wat@wat.wat',
          password: '123456',
          password_confirmation: '123456',
          username: 'wat'
        }
      }
    end
  end
end
