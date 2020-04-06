# frozen_string_literal: true

# UrlValidator
#
#   Used to validate urls
#
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if allow_nil?(options) && value.nil?

    add_error(record, attribute) unless valid_url?(value)
  end

  private

  def allow_nil?(options)
    options.fetch(:allow_nil, false)
  end

  def valid_url?(value)
    (value =~ /\A#{URI.regexp(%w[http https])}\z/).present?
  end

  def add_error(record, attribute)
    record.errors.add(attribute, I18n.t('errors.messages.url.invalid_format'))
  end
end
