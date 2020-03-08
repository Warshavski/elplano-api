# frozen_string_literal: true

# LabelSerializer
#
#   Used for label data representation
#
class LabelSerializer < ApplicationSerializer
  set_type :label

  attributes :title, :description,
             :color, :text_color,
             :created_at, :updated_at
end
