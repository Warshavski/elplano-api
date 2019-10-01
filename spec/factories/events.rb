# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: Event do
    title     { Faker::Lorem.sentence }
    timezone  { 'Etc/GMT+12' }
    start_at  { Faker::Date.forward(days: 1) }

    recurrence {
      [
        'EXDATE;VALUE=DATE:20150610',
        'RDATE;VALUE=DATE:20150609,20150611',
        'RRULE:FREQ=DAILY;UNTIL=20150628;INTERVAL=3'
      ]
    }

    background_color { Faker::Color.hex_color }
    foreground_color { Faker::Color.hex_color }

    creator
  end

  factory :event_params, class: Hash do
    initialize_with do
      {
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph(sentence_count: 5),
        status: 'cancelled',
        start_at: Faker::Date.forward(days: 1),
        end_at: Faker::Date.forward(days: 2),
        timezone: 'Etc/GMT+12',
        recurrence: [
          'EXDATE;VALUE=DATE:20150610',
          'RDATE;VALUE=DATE:20150609,20150611',
          'RRULE:FREQ=DAILY;UNTIL=20150628;INTERVAL=3'
        ],
        eventable_id: create(:student).id,
        eventable_type: 'student',
        background_color: Faker::Color.hex_color,
        foreground_color: Faker::Color.hex_color
      }
    end
  end

  factory :invalid_event_params, class: Hash do
    initialize_with do
      {
        title: nil,
        description: nil,
        status: nil,
        start_at: nil,
        end_at: nil,
        timezone: nil,
        recurrence: [],
        background_color: 'wat',
        foreground_color: 'so'
      }
    end
  end
end
