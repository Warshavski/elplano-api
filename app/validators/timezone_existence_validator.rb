# frozen_string_literal: true

# TimezoneExistenceValidator
#
#   Validates timezone in allowed range
#
class TimezoneExistenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || ActiveSupport::TimeZone[value].blank?
      record.errors.add(attribute, I18n.t(:'errors.messages.not_exists'))
    end
  end
end
