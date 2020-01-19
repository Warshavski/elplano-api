# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :user, class: User, aliases: [:reporter] do
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

    trait :with_identity do
      after(:create) { |user, _| create(:identity, user: user) }
    end

    trait :reset_password do
      after(:build) do |user, _|
        user.reset_password_token = Devise.token_generator.digest(user, :reset_password_token, 'token')
        user.reset_password_sent_at = Time.now
      end
    end
  end

  trait :unconfirmed do
    after(:build) do |user, _|
      user.confirmation_token = Devise.token_generator.digest(user, :confirmation_token, 'token')
      user.confirmed_at = nil
      user.confirmation_sent_at = Time.now.utc
    end
  end

  trait :locked do
    after(:build) do |user, _|
      user.unlock_token = Devise.token_generator.digest(user, :unlock_token, 'token')
      user.locked_at = Time.now.utc
    end
  end

  factory :user_params, class: Hash do
    initialize_with do
      {
        email: 'wat@wat.wat',
        password: '123456',
        password_confirmation: '123456',
        username: 'wat'
      }
    end
  end

  factory :profile_params, class: Hash do
    initialize_with do
      {
        locale: 'en',
        student_attributes: build(:student_params)
      }
    end
  end

  factory :invalid_profile_params, class: Hash do
    initialize_with do
      {
        locale: 'en',
        student_attributes: build(:invalid_student_params)
      }
    end
  end

  factory :invalid_user_params, class: Hash do
    initialize_with do
      {
        email: 'wat_email',
        password: '123456',
        password_confirmation: '',
        username: nil
      }
    end
  end
end
