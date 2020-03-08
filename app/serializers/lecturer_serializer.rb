# frozen_string_literal: true

# LecturerSerializer
#
#   Used for lecturer data representation
#
class LecturerSerializer < ApplicationSerializer
  set_type :lecturer

  attributes :email, :phone, :active, :created_at, :updated_at

  attribute :first_name do |object|
    object.first_name.titleize
  end

  attribute :last_name do |object|
    object.last_name.titleize
  end

  attribute :patronymic do |object|
    object.patronymic.titleize
  end

  attribute :avatar, &:avatar_url

  has_many :courses, serializer: CourseSerializer
end
