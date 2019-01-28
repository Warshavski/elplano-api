# frozen_string_literal: true.

# EventSerializer
#
#   Used for the user data representation
#
class EventSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description, :status, :recurrence,
             :start_at, :end_at, :timezone, :created_at, :updated_at

  belongs_to :creator, serializer: StudentSerializer
end

