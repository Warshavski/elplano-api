# frozen_string_literal: true

module Api
  module V1
    # Api::V1::AssignmentsController
    #
    #   Used to manage authenticated user's(student) task assignment
    #     (accomplish task and apply report for this task)
    #
    class AssignmentsController < ApplicationController
      specify_title_header 'Tasks', 'Assignment'

      specify_serializers default: ::AssignmentSerializer

      # GET : api/v1/tasks/{:task_id}/assignment
      #
      # Get information about task assignment
      #
      def show
        render_resource find_assignment!(params[:task_id]),
                        status: :ok
      end

      # PATCH/PUT : api/v1/tasks/{:task_id}/assignment
      #
      # Update task assignment(accomplish task and apply report)
      #
      def update
        assignment = find_assignment!(params[:task_id])

        TaskReports::Create.call(current_student, assignment, report_params)

        render_resource assignment, status: :ok
      end

      private

      def find_assignment!(task_id)
        current_student.assignments.find_by!(task_id: task_id)
      end

      def report_params
        params.require(:assignment).permit(
          :accomplished, :report,
          extra_links: %i[description url], attachments: []
        )
      end
    end
  end
end
