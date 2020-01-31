# frozen_string_literal: true

FactoryBot.define do
  factory :label, class: Label do
    group

    title       { Faker::Lorem.sentence(word_count: 5) }
    description { Faker::Lorem.sentences(number: 3) }

    color { Faker::Color.hex_color }
  end
end
