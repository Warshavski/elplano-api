# frozen_string_literal: true

module Api
  module V1
    # Api::V1::ClassmatesController
    #
    #   Used to show information about authenticated user's classmates
    #     (students in the same group)
    #
    #     - show group members list
    #     - find group member by it's id
    #
    class ClassmatesController < ApplicationController
      specify_title_header 'Classmates'

      specify_serializers default: StudentSerializer

      # GET : api/v1/classmates
      #
      #
      #   optional filter parameters :
      #
      #     - search - Filter by search term(email, full_name, phone)
      #
      # @see #filter_params
      #
      # Get list of group members
      #
      def index
        classmates = filter_students(filter_params)

        render_collection classmates, status: :ok
      end

      # GET : api/v1/classmates/{:id}
      #
      # Get group member by id
      #
      def show
        student = filter_students.find(params[:id])

        render_resource student, include: %i[user user.status], status: :ok
      end

      private

      def filter_students(filters = {})
        StudentsFinder.call(context: current_group, params: filters)
      end
    end
  end
end
