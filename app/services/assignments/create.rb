# frozen_string_literal: true

module Assignments
  # Assignments::Create
  #
  #   Used to create a new course assignment
  #
  class Create

    # @see #execute
    def self.call(author, params)
      new.execute(author, params)
    end

    # Perform assignment creation
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
    # @option params [Array<String>] :attachments
    #   Collection of attachable files metadata
    #
    # @raise [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound]
    #
    # @return [Assignment]
    #
    def execute(author, params)
      attributes = Compose.call(author, params)

      Assignment.transaction do
        Assignment.create!(attributes).tap do |assignment|
          ::Attachments::Create.call(author.user, assignment, params.fetch(:attachments) { [] })
        end
      end
    end
  end
end
