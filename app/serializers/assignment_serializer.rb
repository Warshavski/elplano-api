# frozen_string_literal: true

# AssignmentSerializer
#
#   Used for course assignment data representation
#
class AssignmentSerializer
  include FastJsonapi::ObjectSerializer

  INCLUDE_ATTACHMENTS = proc do |_, params|
    !params[:exclude]&.include?(:attachments)
  end

  set_type :assignment

  attributes :title, :description,
             :expired_at, :created_at, :updated_at

  attribute :outdated, &:outdated?

  attribute :accomplished, &:accomplished?

  belongs_to :course, serializer: CourseSerializer

  has_many :attachments,
           if: INCLUDE_ATTACHMENTS,
           serializer: AttachmentSerializer
end
