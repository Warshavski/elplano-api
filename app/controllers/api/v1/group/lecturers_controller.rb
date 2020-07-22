# frozen_string_literal: true

module Api
  module V1
    module Group
      # Api::V1::Group::LecturersController
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
        specify_title_header 'Group', 'Lecturers'

        specify_serializers default: LecturerSerializer

        authorize_with! Groups::LecturerPolicy, except: %i[index show]

        rescue_from Errno::ENOENT, KeyError do |e|
          handle_error(e, :missing_file, status: :bad_request, pointer: { pointer: '/data/attributes/avatar' })
        end

        # GET : api/v1/group/lecturers
        #
        # Get list of lecturers
        #
        def index
          lecturers = filter_lecturers

          render_resource lecturers,
                          serializer: ::Groups::ShortLecturerSerializer,
                          status: :ok
        end

        # GET : api/v1/group/lecturers/{:id}
        #
        # Get lecturer by id (information about lecturer)
        #
        def show
          lecturer = filter_lecturers.find(params[:id])

          render_resource lecturer, include: [:courses], status: :ok
        end

        # POST : api/v1/group/lecturers
        #
        # Create new lecturer
        #
        def create
          lecturer = current_group.lecturers.create!(lecturer_params)

          render_resource lecturer, include: [:courses], status: :created
        end

        # PATCH/PUT : api/v1/group/lecturers/{:id}
        #
        # Update lecturer(information about lecturer)
        #
        def update
          lecturer = filter_lecturers.find(params[:id])

          lecturer.update!(lecturer_params)

          render_resource lecturer, include: [:courses], status: :ok
        end

        # DELETE : api/v1/group/lecturers/{:id}
        #
        # Delete lecturer
        #
        def destroy
          filter_lecturers.find(params[:id]).destroy!

          head :no_content
        end

        private

        def filter_lecturers
          current_group&.lecturers || Lecturer.none
        end

        def lecturer_params
          attributes = [:first_name, :last_name, :patronymic, :avatar, :email, :phone, :active, course_ids: []]

          params.require(:lecturer).permit(*attributes)
        end
      end
    end
  end
end
