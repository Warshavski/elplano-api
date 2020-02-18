# frozen_string_literal: true

# Group
#
#   Represent group of students
#
class Group < ApplicationRecord
  include Searchable

  belongs_to :president,
             class_name: 'Student',
             inverse_of: :supervised_group

  has_many :students, dependent: :nullify

  has_many :invites, dependent: :destroy

  has_many :lecturers, dependent: :destroy

  has_many :courses, dependent: :destroy

  has_many :events, as: :eventable, dependent: :destroy

  has_many :labels, dependent: :destroy

  validates :number, presence: true, length: { maximum: 25 }
  validates :title, length: { maximum: 200 }

  # Search groups with the given query
  #
  # @param query [String] - The search query as a String
  #
  # @note This method uses ILIKE on PostgreSQL
  #
  # @return [ActiveRecord::Relation]
  #
  def self.search(query)
    fuzzy_search(query, %i[number title])
  end
end
