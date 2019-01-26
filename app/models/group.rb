# frozen_string_literal: true

# Group
#
#   Represent group of students
#
class Group < ApplicationRecord
  belongs_to :president,
             class_name: 'Student',
             inverse_of: :supervised_group

  has_many :students, dependent: :nullify

  validates :number, presence: true, length: { maximum: 25 }
  validates :title, length: { maximum: 200 }
end
