# frozen_string_literal: true

module Emails
  # Emails::Invite
  #
  #   Used to create email notification about invites.
  #
  module Invite

    # Create notification about new invite
    #
    # @param [Integer] invite_id - Invite ID
    #
    def new_invite(invite_id)
      @invite = ::Invite.find(invite_id)

      mail(to: @invite.email, subject: subject('Invite was created for you'))
    end
  end
end
