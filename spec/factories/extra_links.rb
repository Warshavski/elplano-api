# frozen_string_literal: true

FactoryBot.define do
  factory :extra_link, class: ExtraLink do
    description  { Faker::Lorem.sentence }
    url          { Faker::Internet.url }
  end
end
