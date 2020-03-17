# frozen_string_literal: true

module Api
  module V1
    module Group
      # Api::V1::Group::CoursesController
      #
      #   Used to control courses in the scope of the group
      #
      #   Regular group member's actions:
      #
      #     - get list available courses
      #     - get information about particular course
      #
      #   Group owner actions:
      #
      #     - regular group member's actions
      #     - create a new course
      #     - update information about particular course
      #     - delete particular course
      #
      class CoursesController < ApplicationController
        specify_title_header 'Group', 'Courses'

        specify_serializers default: CourseSerializer

        authorize_with! Groups::CoursePolicy, except: %i[index show]

        # GET : api/v1/group/courses
        #
        #   optional filter parameters :
        #
        #     - active - Filter by availability flag(true/false)
        #
        # @see #filter_params
        #
        # Get list of courses
        #
        def index
          courses = filter_courses(filter_params).preload(:lecturers)

          render_collection courses, status: :ok
        end

        # GET : api/v1/group/courses/{:id}
        #
        # Get course by id (information about course)
        #
        def show
          course = find_course(params[:id])

          render_resource course,
                          include: [:lecturers],
                          status: :ok
        end

        # POST : api/v1/group/courses
        #
        # Create new course
        #
        def create
          course = current_group.courses.create!(course_params)

          render_resource course,
                          include: [:lecturers],
                          status: :created
        end

        # PATCH/PUT : api/v1/group/courses/{:id}
        #
        # Update course(information about course)
        #
        def update
          course = find_course(params[:id])

          course.update!(course_params)

          render_resource course,
                          include: [:lecturers],
                          status: :ok
        end

        # DELETE : api/v1/group/courses/{:id}
        #
        # Delete course
        #
        def destroy
          find_course(params[:id]).tap(&:destroy!)

          head :no_content
        end

        private

        def find_course(id)
          filter_courses.find(id)
        end

        def filter_courses(filters = {})
          CoursesFinder.call(current_group, filters)
        end

        def filter_params
          super(::Courses::IndexContract)
        end

        def course_params
          params.require(:course).permit(:title, :active, lecturer_ids: [])
        end
      end
    end
  end
end
