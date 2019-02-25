# frozen_string_literal: true

# Invite
#
#   Used to invite students to groups
#
class Invite < ApplicationRecord
  belongs_to :group

  belongs_to :sender,
             class_name: 'Student',
             inverse_of: :sent_invites

  belongs_to :recipient,
             class_name: 'Student',
             inverse_of: :invitations,
             optional: true

  validates :group, :sender, presence: true

  validates :recipient, presence: true, on: :update

  validates :invitation_token, uniqueness: true, allow_blank: true

  validates :email, uniqueness: { case_sensitive: false, scope: :group_id }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_invitation_token

  before_validation -> { email&.downcase! }

  #
  # Generates a new random token for invite, and stores
  # the time this token is being generated in sent_at
  #
  def generate_invitation_token
    self.invitation_token = Devise.friendly_token
    self.sent_at = Time.now.utc
  end

  def claim_by!(student)
    update!(recipient: student, accepted_at: Time.now.utc, invitation_token: nil)
  end

  def accepted?
    !accepted_at.nil? && invitation_token.nil?
  end
end
