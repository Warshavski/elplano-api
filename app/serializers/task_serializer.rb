# frozen_string_literal: true

# TaskSerializer
#
#   Used for course task(assignment) data representation
#
class TaskSerializer
  include FastJsonapi::ObjectSerializer

  INCLUDE_ATTACHMENTS = proc do |_, params|
    !params[:exclude]&.include?(:attachments)
  end

  set_type :task

  attributes :title, :description,
             :expired_at, :created_at, :updated_at

  attribute :outdated, &:outdated?

  belongs_to :event, serializer: EventSerializer

  has_many :attachments,
           if: INCLUDE_ATTACHMENTS,
           serializer: AttachmentSerializer
end
