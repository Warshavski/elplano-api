# frozen_string_literal: true

module Api
  module V1
    # Api::V1::TasksController
    #
    #   Used to manage authenticated user's(student) tasks
    #
    class TasksController < ApplicationController
      authorize_with! ::TaskPolicy, only: :create

      set_default_serializer ::TaskSerializer

      denote_title_header 'Tasks'

      # GET : api/v1/tasks
      #
      #   optional filter parameters :
      #
      #     - event_id      - Filter by event identity
      #     - outdated      - Filter by outdated flag(true/false)
      #     - appointed     - Filter by appointment flag(true/false)
      #     - accomplished  - Filter by accomplished flag(true/false)
      #
      # @see #filter_params
      #
      # Get filtered list of tasks
      #
      def index
        render_collection filter_tasks(filter_params),
                          params: { exclude: [:attachments] },
                          status: :ok
      end

      # GET : api/v1/tasks/{:id}
      #
      # Get details information about task
      #
      def show
        task = find_task(params[:id])

        render_resource task,
                        include: %i[event attachments],
                        status: :ok
      end

      # POST : api/v1/tasks
      #
      # Create a new task
      #
      def create
        task = ::Tasks::Create.call(current_student, task_params)

        render_resource task,
                        include: %i[event attachments],
                        status: :created
      end

      # PATCH/PUT : api/v1/tasks/{:id}
      #
      # Update selected task
      #
      def update
        task = find_task(params[:id])

        authorize_action!(task) do |a|
          ::Tasks::Update.call(a, current_student, task_params)
        end

        render_resource task,
                        include: %i[event attachments],
                        status: :ok
      end

      # DELETE : api/v1/tasks/{:id}
      #
      # Delete selected task
      #
      def destroy
        find_task(params[:id]).then do |task|
          authorize_action!(task, &:destroy!)
        end

        head :no_content
      end

      private

      def find_task(id)
        filter_tasks.find(id)
      end

      def filter_tasks(filters = {})
        TasksFinder.new(current_student, filters).execute
      end

      def filter_params
        super(::Tasks::IndexContract)
      end

      def task_params
        params
          .require(:task)
          .permit(
            :title, :description, :expired_at, :event_id,
            attachments: [], student_ids: [], extra_links: []
          )
      end
    end
  end
end
