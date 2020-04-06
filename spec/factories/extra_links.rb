# frozen_string_literal: true

FactoryBot.define do
  factory :extra_link, class: ExtraLink do
    service   { Faker::Company.name }
    url       { Faker::Internet.url }
  end
end
