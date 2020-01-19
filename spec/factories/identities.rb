# frozen_string_literal: true

FactoryBot.define do
  factory :identity, class: Identity do
    user
    provider  { Identity.providers[:facebook] }
    uid       { Faker::Omniauth.facebook[:extra][:raw_info][:id] }
  end
end
