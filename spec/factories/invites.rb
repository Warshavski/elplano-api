# frozen_string_literal: true

FactoryBot.define do
  factory :invite, class: Invite do
    sender  { create(:student) }
    email   { Faker::Internet.email }

    trait :rnd_group do
      after(:build) do |invite, _|
        invite.group = create(:group, students: [invite.sender])
      end
    end

    trait :accepted do
      accepted_at { Time.current }

      after(:create) do |invite, _|
        invite.update!(invitation_token: nil, recipient: create(:student))
      end
    end
  end

  factory :invite_params, class: Hash do
    initialize_with do
      {
        email: Faker::Internet.email
      }
    end
  end

  factory :invalid_invite_params, class: Hash do
    initialize_with do
      {
        email: nil
      }
    end
  end
end
