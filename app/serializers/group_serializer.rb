# frozen_string_literal: true

# GroupSerializer
#
#   Used for the group of students data representation
#
class GroupSerializer < ApplicationSerializer
  set_type :group

  attributes :number, :title, :created_at, :updated_at
end
