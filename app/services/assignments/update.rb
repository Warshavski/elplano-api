# frozen_string_literal: true

module Assignments
  # Assignments::Update
  #
  #   [DESCRIPTION]
  #
  class Update

    # @see #execute
    def self.call(assignment, author, params)
      new.execute(assignment, author, params)
    end

    # Perform assignment update
    #
    # @param assignment [Assignment]
    #   Updateable course assignment
    #
    # @param author [Student]
    #   A student(group owner) who create or update assignment
    #
    # @param params [Hash]
    #   Raw assignment attributes for conversion to a valid format
    #
    # @option params [String] :title
    #   Assignment title(human readable identity)
    #
    # @option params [String] :description
    #   Assignment detailed description
    #
    # @option params [String] :expired_at
    #   Assignment expiration timestamp
    #
    # @option params [Integer] :course_id
    #   Assignment course(for what course this assignment is)
    #
    # @raise [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound]
    #
    # @return [Assignment]
    #
    def execute(assignment, author, params)
      attributes = Compose.call(author, params)

      assignment.tap { |a| a.update!(attributes) }
    end
  end
end
