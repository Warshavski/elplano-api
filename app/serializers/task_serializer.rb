# frozen_string_literal: true

# TaskSerializer
#
#   Used for course task(assignment) data representation
#
class TaskSerializer < ApplicationSerializer
  set_type :task

  attributes :title, :description,
             :expired_at, :created_at, :updated_at

  attribute :outdated, &:outdated?

  belongs_to :event, serializer: EventSerializer

  has_many :attachments,
           lazy_load_data: true,
           serializer: AttachmentSerializer
end
