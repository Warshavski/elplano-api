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
      set_default_serializer StudentSerializer

      denote_title_header 'Classmates'

      # GET : api/v1/classmates
      #
      # Get list of group members
      #
      def index
        render_resource filter_students, status: :ok
      end

      # GET : api/v1/classmates/{:id}
      #
      # Get group member by id
      #
      def show
        student = filter_students.find(params[:id])

        render_resource student, include: [:user], status: :ok
      end

      private

      def filter_students
        current_group.students
      end
    end
  end
end
