# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::UsersController
      #
      #   Application's users management
      #
      class UsersController < Admin::ApplicationController
        specify_title_header 'Users'

        specify_serializers default: UserSerializer

        # GET : api/v1/admin/users
        #
        #   optional filter parameters :
        #
        #     - status - Filter by the user status(active, confirmed, banned)
        #     - search - Filter by search term(email, username)
        #
        # @see #filter_params
        #
        # Get filtered list of users
        #
        def index
          users = filter_users(filter_params).preload(:student, :status)

          render_collection users,
                            include: [:student],
                            status: :ok
        end

        # GET : api/v1/admin/users/{:id}
        #
        # Get information about selected user
        #
        def show
          user = find_user(params[:id])

          render_resource user,
                          include: %i[student status],
                          status: :ok
        end

        # PATCH/PUT : api/v1/admin/users/{:id}
        #
        # Update user state
        #
        def update
          user = find_user(params[:id]).tap do |u|
            ::Admin::Users::Manage.call(current_user, u, params[:action_type])
          end

          render_resource user,
                          include: %i[student status],
                          status: :ok
        end

        # DELETE : api/v1/admin/users/{:id}
        #
        # Delete selected user and associated data
        #
        def destroy
          find_user(params[:id]).tap do |user|
            user.destroy! unless user == current_user
          end

          head :no_content
        end

        private

        def find_user(user_id)
          filter_users.find(user_id)
        end

        def filter_users(filters = {})
          UsersFinder.call(params: filters)
        end

        def filter_params
          super(::Admin::Users::IndexContract)
        end
      end
    end
  end
end
