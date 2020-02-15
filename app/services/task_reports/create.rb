# frozen_string_literal: true

module TaskReports
  # TaskReports::Create
  #
  #   Used to create assignment report(task accomplishment)
  #
  class Create
    # @see #execute
    def self.call(student, assignment, params)
      new.execute(student, assignment, params)
    end

    # Perform assignment accomplishment
    #
    # @param student [Student]
    #   Assignment reported
    #
    # @param assignment [Task]
    #   Reportable assignment
    #
    # @param params [Array<String>]
    #   Assignment params
    #
    # @option params [String] :report
    #   Represents detailed report about task
    #
    # @option params [Boolean] :accomplished
    #   Represents flag if task was accomplished or not
    #
    # @option params [Array<String>] :extra_links
    #   Represents links(URL) to external storage with extra attachments
    #     (google drive for example)
    #
    # @raise [ActiveRecord::RecordInvalid]
    #
    # @return [TaskReport, nil]
    #
    def execute(student, assignment, params)
      assignment_params = params.dup
      attachments_meta  = assignment_params.delete(:attachments) || []

      ApplicationRecord.transaction do
        assignment.tap do
          assignment.update!(assignment_params)
          Attachments::Create.call(student.user, assignment, attachments_meta)
        end
      end
    end
  end
end
