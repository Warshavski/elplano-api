# frozen_string_literal: true

module Invites
  # Invites::Claim
  #
  #   Used to claim invite for user
  #
  class Claim
    attr_reader :recipient

    def self.execute(user, invitation_token)
      new(user).execute(invitation_token)
    end

    def initialize(recipient)
      check_args!(recipient)

      @recipient = recipient
    end

    def execute(invitation_token)
      check_args!(invitation_token)

      invite = find_invite(invitation_token)
      claim_invite!(invite) if valid_invite?(invite)

      invite.reload
    end

    private

    def check_args!(*args)
      args.each { |a| raise ArgumentError, a if a.nil? }
    end

    def find_invite(token)
      Invite.find_by!(invitation_token: token)
    end

    def valid_invite?(invite)
      invite.email == recipient.email
    end

    def claim_invite!(invite)
      ActiveRecord::Base.transaction do
        invite.claim_by!(recipient)
        recipient.student.update!(group: invite.group)
      end
    end
  end
end
