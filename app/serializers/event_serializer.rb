# frozen_string_literal: true

# EventSerializer
#
#   Used for the event data representation
#
class EventSerializer
  include FastJsonapi::ObjectSerializer

  set_type :event

  attributes :title, :description, :status, :recurrence,
             :background_color, :foreground_color,
             :start_at, :end_at, :timezone, :created_at, :updated_at

  belongs_to :creator,
             record_type: :student,
             serializer: StudentSerializer

  belongs_to :course, serializer: CourseSerializer

  belongs_to :eventable, polymorphic: true

  has_many :labels, serializer: LabelSerializer
end
