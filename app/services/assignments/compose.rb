# frozen_string_literal: true

module Assignments
  # Assignment::Composer
  #
  #   Used to compose attributes for assignment update or create
  #
  class Compose

    # @see #execute
    def self.call(author, raw_params)
      new.execute(author, raw_params)
    end

    # Compose assignment attributes for create/update
    #
    # @param author [Student]
    #   A student(group owner) who create or update assignment
    #
    # @param raw_params [Hash]
    #   Raw assignment attributes for conversion to a valid format
    #
    # @option raw_params [String] :title
    #   Assignment title(human readable identity)
    #
    # @option raw_params [String] :description
    #   Assignment detailed description
    #
    # @option raw_params [String] :expired_at
    #   Assignment expiration timestamp
    #
    # @option raw_params [Integer] :course_id
    #   Assignment course(for what course this assignment is)
    #
    # @raise [ActiveRecord::RecordNotFound]
    #
    # @return [Hash]
    #
    def execute(author, raw_params)
      course = find_course!(author, raw_params[:course_id])

      compose_attributes(author, course, raw_params)
    end

    private

    def find_course!(author, course_id)
      author.courses.find(course_id)
    end

    def compose_attributes(author, course, raw_params)
      raw_params
        .slice(:title, :description, :expired_at)
        .merge(author: author, course: course)
    end
  end
end
