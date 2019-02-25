# frozen_string_literal: true

# Lecture
#
#   [DESCRIPTION]
#
class Lecture < ApplicationRecord
  belongs_to :lecturer
  belongs_to :course
end
