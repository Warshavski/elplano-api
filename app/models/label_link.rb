# frozen_string_literal: true

# LabelLink
#
#   Represents link between label and object to which label is attached
#
class LabelLink < ApplicationRecord
  belongs_to :label
  belongs_to :target, polymorphic: true, inverse_of: :label_links

  validates :label, :target, presence: true
end
