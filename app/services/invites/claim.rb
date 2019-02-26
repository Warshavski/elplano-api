# frozen_string_literal: true

module Invites
  # Invites::Claim
  #
  #   Used to claim invite by the user(accept issued invitation)
  #
  class Claim
    attr_reader :recipient

    # Accept an invitation to the group(claim invite by recipient)
    #
    # @param [User] user -
    #   A user who accepts the invite(invitation recipient)
    #
    # @param [String] invitation_token -
    #   A unique token used to find and confirm the invitation
    #
    # @return [Invite]
    #
    def self.call(user, invitation_token)
      new(user).execute(invitation_token)
    end

    # @param [User] recipient -
    #   A user who accepts the invite(invitation recipient)
    #
    def initialize(recipient)
      check_args!(recipient)

      @recipient = recipient
    end

    # Accept an invitation to the group(claim invite by recipient)
    #
    # @param [String] invitation_token -
    #   A unique token used to find and confirm the invitation
    #
    # @return [Invite]
    #
    def execute(invitation_token)
      check_args!(invitation_token)

      invite = find_invite(invitation_token)
      claim_invite!(invite) if valid_invite?(invite)

      invite
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