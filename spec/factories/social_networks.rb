# frozen_string_literal: true

FactoryBot.define do
  factory :social_network, class: SocialNetwork do
    network  { Faker::Internet.domain_name }
    url      { Faker::Internet.url }
  end
end
