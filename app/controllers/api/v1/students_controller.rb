# frozen_string_literal: true

module Api
  module V1
    # Api::V1::StudentsController
    #
    #   Used to represent information about current user(like user profile)
    #
    class StudentsController < ApplicationController
      set_default_serializer StudentSerializer

      # GET : api/v1/student
      #
      # Get student specific information about current user
      #
      def show
        render_json current_user.student, include: [:group], status: :ok
      end

      # PATCH/PUT : api/v1/student
      #
      # Update student specific information about current user
      #
      def update
        student = current_user.student
        student.update!(student_params)

        render_json student, status: :ok
      end

      private

      def student_params
        restify_param(:student)
          .require(:student)
          .permit(:full_name, :email, :phone, :about, social_networks: {})
      end
    end
  end
end
