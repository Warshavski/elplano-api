# frozen_string_literal: true

module Api
  module V1
    # Api::V1::InvitesController
    #
    #   Used to control user's invites(accept/reject and list)
    #
    class InvitesController < ApplicationController
      set_default_serializer InviteSerializer

      # GET : api/v1/invites
      #
      # Get list of user's invites
      #
      def index
        invitations = filter_invites

        render_json invitations, status: :ok
      end

      # GET : api/v1/invites/{:id}
      #
      # Get invite by identity(actually find invite by invitation token)
      #
      def show
        invite = filter_invites.find_by(invitation_token: params[:token])

        render_json invite,
                    include: [:group],
                    params: { exclude: [:students] },
                    status: :ok
      end

      # PATCH/PUT : api/v1/invites/{:id}
      #
      # Claim invite(accept invite by current user)
      #
      def update
        invite = Invites::Claim.execute(current_user, params[:token])

        render_json invite, status: :ok
      end

      private

      def filter_invites
        Invite.where(email: current_user.email)
      end
    end
  end
end
