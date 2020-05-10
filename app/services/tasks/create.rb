# frozen_string_literal: true

module Tasks
  # Tasks::Create
  #
  #   Used to create a new event task
  #
  class Create
    include Loggable

    # @see #execute
    def self.call(author, params)
      new.execute(author, params)
    end

    # Perform task creation
    #
    # @param author [Student]
    #   A student(group owner) who create or update task
    #
    # @param params [Hash]
    #   Raw task attributes for conversion to a valid format
    #
    # @option params [String] :title
    #   Task title(human readable identity)
    #
    # @option params [String] :description
    #   Task detailed description
    #
    # @option params [Array<String>] :extra_links
    #   Links to external resources with additional info(Google Cloud for example)
    #
    # @option params [String] :expired_at
    #   Task expiration timestamp
    #
    # @option params [Integer] :event_id
    #   Task event(for what event this task is)
    #
    # @option params [Array<String>] :attachments
    #   Collection of attachable files metadata
    #
    # @option params [Array<Integer>] :student_ids
    #   Collection of the students who are assigned to the task
    #
    # @raise [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound]
    #
    # @return [Task]
    #
    def execute(author, params)
      attributes = Compose.call(author, params)

      ApplicationRecord.transaction do
        Task.create!(attributes).tap do |task|
          ::Attachments::Create.call(author.user, task, params.fetch(:attachments) { [] })
          log_activity!(:created, author.user, task)
        end
      end
    end
  end
end
