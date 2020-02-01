# frozen_string_literal: true

# ColorMatchable
#
#   Provides additions to generate matching colors
#
module ColorMatchable
  extend ActiveSupport::Concern

  NIGHT_RIDER = '#333333'
  WHITE = '#FFFFFF'

  def generate_text_color(bg_color)
    r, g, b = split_color(bg_color)

    (r + g + b) > 500 ? NIGHT_RIDER : WHITE
  end

  def split_color(color)
    if color.length == 4
      color[1, 4].scan(/./).map { |v| (v * 2).hex }
    else
      color[1, 7].scan(/.{2}/).map(&:hex)
    end
  end
end
