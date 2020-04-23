# frozen_string_literal: true

FactoryBot.define do
  factory :user_status, class: UserStatus do
    user
    message { Faker::Lorem.sentence }
    emoji   { 'cat' }
  end
end
