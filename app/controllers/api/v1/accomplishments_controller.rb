# frozen_string_literal: true

module Api
  module V1
    # Api::V1::AccomplishmentsController
    #
    #   Used to manage authenticated user's(student) assignment accomplishment
    #     (accomplish assignment or remove assignment accomplishment)
    #
    class AccomplishmentsController < ApplicationController
      denote_title_header 'Assignments', 'Accomplishment'

      # POST : api/v1/assignments/{:assignment_id}/accomplishment
      #
      # Accomplish selected assignment
      #
      def create
        assignment = find_assignment(params[:assignment_id])

        Accomplishments::Create.call(current_student, assignment, accomplishment_params)

        render_meta({ message: I18n.t('generic.messages.saved') }, status: :created)
      end

      # DELETE : api/v1/assignments/{:assignment_id}/accomplishment
      #
      # Delete selected assignment accomplishment
      #
      def destroy
        find_accomplishment!(params[:assignment_id]).tap(&:destroy!)

        head :no_content
      end

      private

      def find_assignment(id)
        filter_assignments.find(id)
      end

      def filter_assignments(filters = {})
        AssignmentsFinder.new(current_student, filters).execute
      end

      def find_accomplishment!(assignment_id)
        current_student.accomplishments.find_by!(assignment_id: assignment_id)
      end

      def accomplishment_params
        params.require(:accomplishment).permit(attachments: [])
      end
    end
  end
end
