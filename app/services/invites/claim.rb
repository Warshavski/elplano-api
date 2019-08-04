# frozen_string_literal: true

module Invites
  # Invites::Claim
  #
  #   Used to claim invite by the student(accept issued invitation)
  #
  class Claim
    attr_reader :recipient

    # Accept an invitation to the group(claim invite by recipient)
    #
    # @param [Student] student -
    #   A student who accepts the invite(invitation recipient)
    #
    # @param [String] invitation_token -
    #   A unique token used to find and confirm the invitation
    #
    # @return [Invite]
    #
    def self.call(student, invitation_token)
      new(student).execute(invitation_token)
    end

    # @param [Student] recipient -
    #   A student who accepts the invite(invitation recipient)
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

      find_invite(invitation_token).tap do |invite|
        claim_invite!(invite) if valid_invite?(invite)
      end
    end

    private

    def check_args!(*args)
      args.each { |a| raise ArgumentError, a if a.nil? }
    end

    def find_invite(token)
      Invite.find_by!(invitation_token: token)
    end

    def valid_invite?(invite)
      invite.email == recipient.user.email
    end

    def claim_invite!(invite)
      ActiveRecord::Base.transaction do
        invite.claim_by!(recipient)
        recipient.update!(group: invite.group)
      end
    end
  end
end
