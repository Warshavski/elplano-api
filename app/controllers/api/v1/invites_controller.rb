# frozen_string_literal: true

module Api
  module V1
    # Api::V1::InvitesController
    #
    #   Used to control user's invites(accept/reject and list)
    #
    class InvitesController < ApplicationController
      specify_title_header 'Invites'

      specify_serializers default: InviteSerializer

      # GET : api/v1/invites
      #
      def index
        invitations = filter_invites.preload(:group)

        render_resource invitations,
                        include: [:group],
                        status: :ok
      end

      # GET : api/v1/invites/{:id}
      #
      # Get invite by identity(actually find invite by invitation token)
      #
      def show
        invite = filter_invites.find_by(invitation_token: params[:token])

        render_resource invite,
                        include: [:group],
                        status: :ok
      end

      # PATCH/PUT : api/v1/invites/{:id}
      #
      # Claim invite(accept invite by current user)
      #
      def update
        invite = Invites::Claim.call(current_student, params[:token])

        render_resource invite, status: :ok
      end

      private

      def filter_invites
        Invite.where(email: current_user.email)
      end
    end
  end
end
