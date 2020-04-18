# frozen_string_literal: true

FactoryBot.define do
  factory :announcement, class: Announcement do
    message { Faker::Lorem.sentence(word_count: 5) }

    start_at  { 1.day.ago }
    end_at    { 1.day.from_now }

    background_color { Faker::Color.hex_color }
    foreground_color { Faker::Color.hex_color }

    trait :current do
      start_at  { 1.day.ago }
      end_at    { 1.day.from_now }
    end

    trait :expired do
      start_at  { 5.days.ago }
      end_at    { 3.days.ago }
    end

    trait :upcoming do
      start_at  { 5.days.from_now }
      end_at    { 6.days.from_now }
    end

    trait :skip_validation do
      to_create { |instance| instance.save(validate: false) }
    end
  end

  factory :announcement_params, class: Hash do
    initialize_with do
      {
        message: Faker::Lorem.sentence(word_count: 5),
        start_at: 1.day.ago,
        end_at: 1.day.from_now,
        background_color: Faker::Color.hex_color,
        foreground_color: Faker::Color.hex_color
      }
    end
  end

  factory :invalid_announcement_params, class: Hash do
    initialize_with do
      {
        message: nil,
        start_at: 1.day.ago,
        end_at: 1.day.from_now,
        background_color: 'wat',
        foreground_color: 'color'
      }
    end
  end
end
