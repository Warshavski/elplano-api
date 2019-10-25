# frozen_string_literal: true

FactoryBot.define do
  factory :abuse_report, class: AbuseReport do
    message  { Faker::Lorem.paragraph(sentence_count: 6) }

    reporter
    user
  end
end
