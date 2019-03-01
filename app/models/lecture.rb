# frozen_string_literal: true

# Lecture
#
#   Used to represent link between course and lecturer.
#     (all the courses that lecturer takes part in)
#
class Lecture < ApplicationRecord
  belongs_to :lecturer
  belongs_to :course
end
