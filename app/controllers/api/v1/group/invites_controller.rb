# frozen_string_literal: true

module Api
  module V1
    module Group
      # Api::V1::Group::InvitesController
      #
      #   Used to control group members invitations
      #
      class InvitesController < ApplicationController
        set_default_serializer InviteSerializer

        before_action :authorize_student!

        # GET : api/v1/group/invites
        #
        # Get list of group invites
        #
        def index
          render_resource filter_invites, status: :ok
        end

        # GET : api/v1/group/invites/{:id}
        #
        # Get group invites by id
        #
        def show
          invite = filter_invites.find(params[:id])

          render_resource invite, status: :ok
        end

        # POST : api/v1/group/invites
        #
        # Create new invitation
        #
        def create
          invite = Invites::Create.call(
            current_student,
            invite_params.merge(group: current_group)
          )

          render_resource invite, status: :created
        end

        private

        def authorize_student!
          return if current_student.group_owner?

          raise Elplano::Errors::AuthError, I18n.t(:'errors.messages.access_denied')
        end

        def filter_invites
          current_group.invites
        end

        def invite_params
          restify_param(:invite)
            .require(:invite)
            .permit(:email)
        end
      end
    end
  end
end
