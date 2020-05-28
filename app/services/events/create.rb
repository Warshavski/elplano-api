# frozen_string_literal: true

module Events
  # Events::Create
  #
  #   Used to create an event
  #
  class Create < Base
    ALLOWED_TYPES = %w[student group].freeze

    # see #execute
    def self.call(author, params, &block)
      new.execute(author, params, &block)
    end

    # Perform event creation
    #
    # @param author [Student] - Event owner(creator)
    # @param params [Hash]  - Events params(attributes)
    #
    # @option params [String] :title -
    #   Event title(human readable identity)
    #
    # @option params [String] :description -
    #   Detailed event description
    #
    # @option params [String] :status -
    #   Represents event current status.
    #     - confirmed - The event is confirmed. This is the default status.
    #     - tentative - The event is tentatively confirmed.
    #     - cancelled - The event is cancelled (deleted).
    #
    # @option params [DateTime] :start_at -
    #   Represents when event starts
    #
    # @option params [DateTime] :end_at -
    #   Represents when event ends.
    #
    # @option params [String] :timezone -
    #   Timezone settings
    #
    # @option params [Integer] :course_id -
    #   (optional) The course identity to which the event is attached
    #
    # @option params [Integer] :eventable_id -
    #   The entity type to which the event is attached(Student, Group)
    #
    # @option params [String] :eventable_type -
    #   The entity identity to which the event is attached
    #
    # @option params [String] :background_color -
    #   The background color presented by HEX
    #
    # @option params [String] :foreground_color -
    #   The foreground color that can be used to write on top of
    #   a background with 'background' color presented by HEX
    #
    # @option params [Array<String>] :recurrence -
    #   Recurrence rules if an event is recurrent
    #
    # @option params [Array<Integer>] :label_ids -
    #   Collection of the labels ids
    #
    # @yield - Additional logic such as authorization
    #
    # @raise [ActiveRecord::RecordInvalid]
    # @return [Event, Array<Event>]
    #
    def execute(author, params)
      event = build_event(author, params.dup)

      yield(event) if event.valid? && block_given?

      save_with_logging!(event, :created)
    end

    private

    def build_event(author, params)
      events_relation = author.created_events

      event = events_relation.build(params.except(:label_ids)) do |e|
        e.eventable_type = nil unless type_allowed?(e.eventable_type)
      end

      resolve_labels!(event, author.group, params[:label_ids])
    end

    def resolve_labels!(event, group, label_ids)
      return event if group.nil?

      event.tap do |e|
        e.labels = group.labels.where(id: label_ids)
      end
    end

    def type_allowed?(type)
      ALLOWED_TYPES.include?(type)
    end
  end
end
