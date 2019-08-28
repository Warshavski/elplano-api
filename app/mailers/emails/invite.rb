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
    def invitation(invite_id)
      @invite = ::Invite.find(invite_id)

      mail(
        to: @invite.email,
        subject: subject(I18n.t(:'notifications.email.invite.subject'))
      )
    end
  end
end
