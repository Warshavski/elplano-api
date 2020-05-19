# frozen_string_literal: true

# ColorValidator
#
#   Used to check if the value of an attribute is a valid hex color.
#
# @example Validate that the event color is a valid hex color.
#   class Event < ActiveRecord::Base
#     attr_accessor :color_attribute
#
#     validates :color_attribute, color: true
#   end
#
class ColorValidator < ActiveModel::EachValidator
  HEX_COLOR_FORMAT = /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/.freeze

  def validate_each(record, attribute, value)
    return if allow_nil?(options) && value.nil?

    add_error(record, attribute) unless valid_format?(value)
  end

  private

  def allow_nil?(options)
    options.fetch(:allow_nil, false)
  end

  def valid_format?(color)
    (color =~ HEX_COLOR_FORMAT).present?
  end

  def add_error(record, attribute)
    record.errors.add(attribute, I18n.t('errors.messages.validators.color.invalid_format'))
  end
end
