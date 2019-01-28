# frozen_string_literal: true

# TimezoneExistenceValidator
#
#   Validates timezone in allowed range
#
class TimezoneExistenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if ActiveSupport::TimeZone[value].blank?
      record.errors.add(attribute, 'does not exist')
    end
  end
end
