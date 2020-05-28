# frozen_string_literal: true

module Groups
  # Groups::ShortCourseSerializer
  #
  #   Used to represent collection of courses in the scope of group
  #
  class ShortCourseSerializer < ApplicationSerializer
    set_type :course

    attributes :active, :created_at, :updated_at

    attribute :title do |object|
      object.title.titleize
    end
  end
end
