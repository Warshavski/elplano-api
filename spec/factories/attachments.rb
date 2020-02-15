# frozen_string_literal: true

FactoryBot.define do
  factory :attachment, class: Attachment do
    attachable { build(:task) }
    author     { build(:user) }
  end
end
