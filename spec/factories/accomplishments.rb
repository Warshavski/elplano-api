# frozen_string_literal: true

FactoryBot.define do
  factory :accomplishment, class: Accomplishment do
    student
    assignment
  end
end
