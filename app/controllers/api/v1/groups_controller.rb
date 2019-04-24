# frozen_string_literal: true

module Api
  module V1
    # Api::V1::GroupsController
    #
    #   Used to control current user's group.
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
      set_default_serializer GroupSerializer

      before_action :authorize_edit, only: %i[update destroy]
      before_action :authorize_create, only: :create

      # GET : api/v1/group
      #
      # Get detailed information about current user's group
      #
      def show
        render_resource current_group, status: :ok
      end

      # POST : api/v1/group
      #
      # Creates new group
      #
      def create
        group = Groups::Create.call(current_student, group_params)

        render_resource group, status: :created
      end

      # PATCH/PUT : api/v1/group
      #
      # Updates/renew information about current user's group
      #
      def update
        supervised_group.update!(group_params)

        render_resource supervised_group, status: :ok
      end

      # DELETE : api/v1/group
      #
      # Deletes current user's supervised group
      #
      def destroy
        supervised_group.destroy!

        head :no_content
      end

      private

      def authorize_edit
        return if current_student.group_owner?

        raise Elplano::Errors::AuthError, I18n.t(:'errors.messages.access_denied')
      end

      def authorize_create
        return unless current_student.any_group?

        raise Elplano::Errors::AuthError, I18n.t(:'errors.messages.access_denied')
      end

      def group_params
        restify_param(:group)
          .require(:group)
          .permit(:title, :number)
      end
    end
  end
end
