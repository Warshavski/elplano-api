# frozen_string_literal: true

FactoryBot.define do
  factory :bug_report, class: BugReport do
    message  { Faker::Lorem.paragraph(sentence_count: 6) }
    reporter
  end
end
