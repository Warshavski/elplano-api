# frozen_string_literal: true

module Api
  module V1
    # Api::V1::AssignmentsController
    #
    #   Used to manage authenticated user's(student) assignments
    #
    class AssignmentsController < ApplicationController
      authorize_with! ::AssignmentPolicy, only: :create

      set_default_serializer ::AssignmentSerializer

      denote_title_header 'Assignments'

      # GET : api/v1/assignments
      #
      #   optional filter parameters :
      #
      #     - course_id - Filter by course identity
      #     - outdated  - Filter by outdated flag(true/false)
      #
      # @see #filter_params
      #
      # Get filtered list of assignments
      #
      def index
        render_resource filter_assignments(filter_params),
                        status: :ok
      end

      # GET : api/v1/assignments/{:id}
      #
      # Get details information about assignment
      #
      def show
        render_resource find_assignment(params[:id]),
                        include: [:course],
                        status: :ok
      end

      # POST : api/v1/assignments
      #
      # Create a new assignment
      #
      def create
        assignment = Assignments::Create.call(current_student, assignment_params)

        render_resource assignment,
                        include: [:course],
                        status: :created
      end

      # PATCH/PUT : api/v1/assignments/{:id}
      #
      # Update selected assignment
      #
      def update
        assignment = find_assignment(params[:id])

        authorize_action!(assignment) do |a|
          Assignments::Update.call(a, current_student, assignment_params)
        end

        render_resource assignment,
                        include: [:course],
                        status: :ok
      end

      # DELETE : api/v1/assignments/{:id}
      #
      # Delete selected assignment
      #
      def destroy
        find_assignment(params[:id]).tap do |assignment|
          authorize_action!(assignment, &:destroy!)
        end

        head :no_content
      end

      private

      def find_assignment(id)
        filter_assignments.find(id)
      end

      def filter_assignments(filters = {})
        AssignmentsFinder.new(current_student, filters).execute
      end

      def authorize_action!(entity)
        authorize! entity

        yield(entity) if block_given?
      end

      def filter_params
        validate_with(::Assignments::IndexContract.new, params[:filters])
      end

      def assignment_params
        params.require(:assignment).permit(:title, :description, :expired_at, :course_id)
      end
    end
  end
end
