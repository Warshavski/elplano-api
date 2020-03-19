# frozen_string_literal: true

module Invites
  # Invites::Create
  #
  #   Used to create(issue) new invite
  #
  class Create
    include Loggable

    attr_reader :sender

    # Create and send invite
    #
    # @param [Student] sender -
    #   The student who initiates the invitation to the group(originally group owner)
    #
    # @param [Hash] params -
    #   The parameters that determine the recipient and group for the invitation
    #
    # @option params [String] :email - Email address of the recipient(used to send an invitation)
    # @option params [Group]  :group - The group to which the recipient will join after accepting the invitation
    #
    # @raise [Api::ArgumentMissing] error on invalid input(nil sender)
    #
    # @return [Invite]
    #
    def self.call(sender, params)
      new(sender).execute(params)
    end

    # @param [Student] sender -
    #   The student who initiates the invitation to the group(originally group owner)
    #
    # @raise [Api::ArgumentMissing] error on invalid input(nil sender)
    #
    def initialize(sender)
      raise Api::ArgumentMissing, sender if sender.nil?

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
      invite = ApplicationRecord.transaction do
        create_invite!(params).tap do |i|
          log_activity!(:created, sender.user, i)
        end
      end

      invite.tap { notify_about(invite) }
    end

    private

    def create_invite!(params)
      Invite.create!(params) { |i| i.sender = sender }
    end

    def notify_about(invite)
      Notify.invitation(invite.id).deliver_later
    end
  end
end
