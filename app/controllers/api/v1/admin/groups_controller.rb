# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::GroupsController
      #
      #   Application's groups management
      #
      class GroupsController < Admin::ApplicationController
        specify_title_header 'Groups'

        specify_serializers default: ::Admin::GroupSerializer

        # GET : api/v1/admin/groups
        #
        #   optional filter parameters :
        #
        #     - search - Filter by search term(number, title)
        #
        # @see #filter_params
        #
        # Get filtered list of groups
        #
        def index
          groups = filter_groups(filter_params).preload(president: :user)

          render_collection groups,
                            include: %i[president.user],
                            status: :ok
        end

        # GET : api/v1/admin/groups/{:id}
        #
        # Get information about requested group
        #
        def show
          group = filter_groups.preload(students: :user).find(params[:id])

          render_resource group,
                          include: %i[president.user students.user],
                          status: :ok
        end

        private

        def filter_groups(filters = {})
          GroupsFinder.call(filters)
        end
      end
    end
  end
end
