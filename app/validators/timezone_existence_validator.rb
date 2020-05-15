# frozen_string_literal: true

# TimezoneExistenceValidator
#
#   Validates timezone in allowed range
#
class TimezoneExistenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    add_error(record, attribute) if invalid_timezone?(value)
  end

  private

  def invalid_timezone?(value)
    value.nil? || ActiveSupport::TimeZone[value].blank?
  end

  def add_error(record, attribute)
    record.errors.add(attribute, I18n.t(:'errors.messages.timezone.not_exist'))
  end
end
