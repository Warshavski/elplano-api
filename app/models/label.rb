# frozen_string_literal: true

# Label
#
#   Used to add additional labeling(tagging) for resources
#
class Label < ApplicationRecord
  include ColorMatchable
  include Searchable

  CURIOUS_BLUE = '#428BCA'
  DEFAULT_COLOR = CURIOUS_BLUE

  belongs_to :group

  has_many :label_links, dependent: :delete_all
  has_many :events, through: :label_links, source: :target, source_type: 'Event'

  validates :color, color: true, allow_blank: false

  validates :title,
            presence: true,
            length: { maximum: 255 },
            format: { with: /\A[^,]+\z/ },
            uniqueness: { case_sensitive: false, scope: [:group_id] }

  before_validation :normalize_attributes

  class << self
    # Search students with the given query
    #
    # @param query [String] - The search query as a String
    #
    # @note This method uses ILIKE on PostgreSQL
    #
    # @return [ActiveRecord::Relation]
    #
    def search(query)
      return none if query.blank?

      fuzzy_search(query.downcase, %i[title description])
    end
  end

  def text_color
    generate_text_color(color)
  end

  private

  def normalize_attributes
    self.color = color.blank? ? DEFAULT_COLOR : color.strip.upcase
    self.title = title&.strip&.downcase
  end
end
