# frozen_string_literal: true

module Invites
  # Invites::Claim
  #
  #   Used to claim invite by the student(accept issued invitation)
  #
  class Claim
    # Accept an invitation to the group(claim invite by recipient)
    #
    # @param [Student] student -
    #   A student who accepts the invite(invitation recipient)
    #
    # @param [String] invitation_token -
    #   A unique token used to find and confirm the invitation
    #
    # @raise [Api::ArgumentMissing, ActiveRecord::RecordNotFound]
    # @return [Invite]
    #
    def self.call(student, invitation_token)
      new.execute(student, invitation_token)
    end

    # Accept an invitation to the group(claim invite by recipient)
    #
    # @param [Student] recipient -
    #   A student who accepts the invite(invitation recipient)
    #
    # @param [String] invitation_token -
    #   A unique token used to find and confirm the invitation
    #
    # @raise [Api::ArgumentMissing, ActiveRecord::RecordNotFound]
    # @return [Invite]
    #
    def execute(recipient, invitation_token)
      check_args!(recipient)
      check_args!(invitation_token)

      find_invite(invitation_token).tap do |invite|
        claim_invite!(invite, recipient) if valid_invite?(invite, recipient)
      end
    end

    private

    def check_args!(*args)
      args.each { |a| raise Api::ArgumentMissing, a if a.nil? }
    end

    def find_invite(token)
      Invite.find_by!(invitation_token: token)
    end

    def valid_invite?(invite, recipient)
      invite.email == recipient.user.email
    end

    def claim_invite!(invite, recipient)
      ActiveRecord::Base.transaction do
        invite.claim_by!(recipient)
        recipient.update!(group: invite.group)
      end
    end
  end
end
