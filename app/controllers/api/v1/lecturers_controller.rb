# frozen_string_literal: true

module Api
  module V1
    # Api::V1::LecturersController
    #
    #   Used to control lecturers in the scope of the group
    #
    #   Regular group member's actions:
    #
    #     - list available lecturers
    #     - get information about particular lecturer
    #
    #   Group owner actions:
    #
    #     - regular group member's actions
    #     - create a new lecturer
    #     - update information about particular lecturer
    #     - delete particular lecturer
    #
    class LecturersController < ApplicationController
      set_default_serializer LecturerSerializer

      before_action :authorize_edit!, only: %i[create update destroy]

      # GET : api/v1/group/lecturers
      #
      # Get list of lecturers
      #
      def index
        lecturers = filter_lecturers.eager_load(:courses)

        render_resource lecturers, status: :ok
      end

      # GET : api/v1/group/lecturers/{:id}
      #
      # Get lecturer by id (information about lecturer)
      #
      def show
        lecturer = filter_lecturers.find(params[:id])

        render_resource lecturer, status: :ok
      end

      # POST : api/v1/group/lecturers
      #
      # Create new lecturer
      #
      def create
        lecturer = current_group.lecturers.create!(lecturer_params)

        render_resource lecturer, status: :created
      end

      # PATCH/PUT : api/v1/group/lecturers/{:id}
      #
      # Update lecturer(information about lecturer)
      #
      def update
        lecturer = filter_lecturers.find(params[:id])

        lecturer.update!(lecturer_params)

        render_resource lecturer, status: :ok
      end

      # DELETE : api/v1/group/lecturers/{:id}
      #
      # Delete lecturer
      #
      def destroy
        lecturer = filter_lecturers.find(params[:id])

        lecturer.destroy!

        head :no_content
      end

      private

      def filter_lecturers
        current_group&.lecturers || Lecturer.none
      end

      def authorize_edit!
        return if current_student.group_owner?

        raise Elplano::Errors::AuthError, I18n.t(:'errors.messages.access_denied')
      end

      def lecturer_params
        restify_param(:lecturer)
          .require(:lecturer)
          .permit(:first_name, :last_name, :patronymic, course_ids: [])
      end
    end
  end
end
