# frozen_string_literal: true

# InviteSerializer
#
#   Used for invite data representation
#
class InviteSerializer
  include FastJsonapi::ObjectSerializer

  set_type :invite

  attributes :email, :invitation_token,
             :sent_at, :accepted_at,
             :created_at, :updated_at

  attribute :status do |object|
    object.accepted? ? :accepted : :pending
  end

  belongs_to :sender,
             record_type: :student,
             serializer: StudentSerializer

  belongs_to :recipient,
             record_type: :student,
             serializer: StudentSerializer

  belongs_to :group, serializer: GroupSerializer
end
