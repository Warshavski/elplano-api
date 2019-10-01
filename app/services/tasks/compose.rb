# frozen_string_literal: true

module Tasks
  # Task::Composer
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
    #   Task title(human readable identity)
    #
    # @option raw_params [String] :description
    #   Task detailed description
    #
    # @option raw_params [Array<String>] :extra_links
    #   Links to external resources with additional info(Google Cloud for example)
    #
    # @option raw_params [String] :expired_at
    #   Task expiration timestamp
    #
    # @option raw_params [Integer] :event_id
    #   Task event(for what event this assignment is)
    #
    # @option raw_params [Array<Integer>] :student_ids
    #   Collection of the students who are assigned to the task
    #
    # @raise [ActiveRecord::RecordNotFound]
    #
    # @return [Hash]
    #
    def execute(author, raw_params)
      find_event!(author, raw_params[:event_id]).then do |event|
        compose_attributes(author, event, raw_params)
      end
    end

    private

    def find_event!(author, event_id)
      author.created_events.find(event_id)
    end

    def compose_attributes(author, event, raw_params)
      students = resolve_students(author, raw_params[:student_ids])

      raw_params
        .slice(:title, :description, :extra_links, :expired_at)
        .merge(author: author, event: event)
        .tap { |p| p.merge!(students: students) unless students.nil? }
    end

    def resolve_students(author, student_ids)
      return nil if student_ids.nil?
      return [] if student_ids.empty?

      students = author.classmates.where(id: student_ids).to_a

      students.empty? ? nil : students
    end
  end
end
