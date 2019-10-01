# frozen_string_literal: true

# Assignment
#
#   Represents course assignment(homework) for students in a group witch the course is belongs to
#
class Assignment < ApplicationRecord
  belongs_to :author, class_name: 'Student', foreign_key: :author_id
  belongs_to :course

  scope :outdated,  -> { where('expired_at < ?', Time.current) }
  scope :active,    -> { where('expired_at > ?', Time.current).or(where(expired_at: nil)) }

  validates :title, presence: true

  validates :expired_at,
            allow_nil: true,
            timeliness: { after: -> { Time.current } }

  def outdated?
    expired_at.nil? ? false : (expired_at < Time.current)
  end
end
