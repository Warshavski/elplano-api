# frozen_string_literal: true

module Accomplishments
  # Accomplishments::Create
  #
  #   [DESCRIPTION]
  #
  class Create
    # @see #execute
    def self.call(student, assignment, params)
      new.execute(student, assignment, params)
    end

    # Perform assignment accomplishment
    #
    # @param student [Student]
    #   [DESCRIPTION]
    #
    # @param assignment [Assignment]
    #   [DESCRIPTION]
    #
    # @param params [Array<String>]
    #   [DESCRIPTION]
    #
    # @raise [ActiveRecord::RecordInvalid]
    #
    # @return [Accomplishment, nil]
    #
    def execute(student, assignment, params)
      return if already_accomplished?(student, assignment)

      Accomplishment.transaction do
        Accomplishment.create!(student: student, assignment: assignment).tap do |accomplishment|
          Attachments::Create.call(student.user, accomplishment, params.fetch(:attachments) { [] })
        end
      end
    end

    private

    def already_accomplished?(student, assignment)
      Accomplishment.exists?(student_id: student.id, assignment: assignment.id)
    end
  end
end
