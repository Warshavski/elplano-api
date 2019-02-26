# frozen_string_literal: true

module Invites
  # Invites::Create
  #
  #   Used to create(issue) new invite
  #
  class Create
    attr_reader :sender

    # Create and send invite
    #
    # @param [User] sender -
    #   The user who initiates the invitation to the group(originally group owner)
    #
    # @param [Hash] params -
    #   the parameters that determine the recipient and group for the invitation
    #
    # @option params [String] :email - Email address of the recipient(used to send an invitation)
    # @option params [Group]  :group - The group to which the recipient will join after accepting the invitation
    #
    # @return [Invite]
    #
    def self.call(sender, params)
      new(sender).execute(params)
    end

    # @param [User] sender -
    #   The user who initiates the invitation to the group(originally group owner)
    #
    def initialize(sender)
      raise ArgumentError, sender if sender.nil?

      @sender = sender
    end

    # Create and send invitation
    #
    # @param [Hash] params -
    #   the parameters that determine the recipient and group for the invitation
    #
    # @option params [String] :email - Email address of the recipient(used to send an invitation)
    # @option params [Group]  :group - The group to which the recipient will join after accepting the invitation
    #
    # @return [Invite]
    #
    def execute(params)
      invite = create_invite!(params)

      notify_about(invite)

      invite
    end

    private

    def create_invite!(params)
      Invite.create!(params) { |i| i.sender = sender }
    end

    def notify_about(invite)
      Notify.new_invite(invite.id).deliver_later
    end
  end
end