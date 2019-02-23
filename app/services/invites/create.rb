# frozen_string_literal: true

module Invites
  # Invites::Create
  #
  #   Used to create(issue) new invite
  #
  class Create

    attr_reader :sender

    def self.execute(sender, params)
      new(sender).execute(params)
    end

    def initialize(sender)
      raise ArgumentError, sender if sender.nil?

      @sender = sender
    end

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
