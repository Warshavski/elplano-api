# frozen_string_literal: true

module Tasks
  # Tasks::Update
  #
  #   Used to perform task update
  #
  class Update
    include Loggable

    # @see #execute
    def self.call(task, author, params)
      new.execute(task, author, params)
    end

    # Perform task update
    #
    # @param task [Task]
    #   Updateable event task
    #
    # @param author [Student]
    #   A student(group owner) who creates or updates task
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
    #   Task course(for what event this task is)
    #
    # @option params [Array<Integer>] :student_ids
    #   Collection of the students who are assigned to the task
    #
    # @raise [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound]
    #
    # @return [Task]
    #
    def execute(task, author, params)
      attributes = Compose.call(author, params)

      task.tap do |t|
        ApplicationRecord.transaction do
          log_activity!(:updated, author.user, t, details: task.attributes)
          t.update!(attributes)
        end
      end
    end
  end
end
