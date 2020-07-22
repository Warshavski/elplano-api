# frozen_string_literal: true

module Api
  module V1
    # Api::V1::GroupsController
    #
    #   Used to control current user's(authenticated user) group.
    #
    #   Regular group member can:
    #
    #     - obtain information about his group.
    #
    #   President can:
    #
    #     - obtain information about group.
    #     - update information about group.
    #     - delete information about group.
    #
    #   User with no group can:
    #
    #     - create a new group and become a group president.
    #
    class GroupsController < ApplicationController
      specify_title_header 'Group'

      specify_serializers default: GroupSerializer

      authorize_with! GroupPolicy, except: :show

      # GET : api/v1/group
      #
      def show
        render_resource current_group, status: :ok
      end

      # POST : api/v1/group
      #
      def create
        group = Groups::Create.call(current_student, group_params)

        render_resource group, status: :created
      end

      # PATCH/PUT : api/v1/group
      #
      def update
        supervised_group.update!(group_params)

        render_resource supervised_group, status: :ok
      end

      # DELETE : api/v1/group
      #
      def destroy
        ::Groups::Destroy.call(supervised_group, current_user)

        head :no_content
      end

      private

      def group_params
        params.require(:group).permit(:title, :number)
      end
    end
  end
end
