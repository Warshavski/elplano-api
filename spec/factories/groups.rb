# frozen_string_literal: true

FactoryBot.define do
  factory :group, class: Group do
    number  { Faker::Number.number }
    title   { Faker::Lorem.sentence(3) }

    president
  end
end
