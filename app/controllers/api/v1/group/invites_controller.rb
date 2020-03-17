# frozen_string_literal: true

module Api
  module V1
    module Group
      # Api::V1::Group::InvitesController
      #
      #   Used to control group members invitations
      #
      class InvitesController < ApplicationController
        specify_title_header 'Group', 'Invites'

        specify_serializers default: InviteSerializer

        authorize_with! Groups::InvitePolicy

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

        def filter_invites
          current_group.invites
        end

        def invite_params
          params.require(:invite).permit(:email)
        end
      end
    end
  end
end
