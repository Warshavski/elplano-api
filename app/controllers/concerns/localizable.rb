# frozen_string_literal: true

# Localizable
#
#   Used to add support for different locales
#
module Localizable
  extend ActiveSupport::Concern

  included do
    before_action :configure_locale
  end

  private

  def configure_locale
    locale = user_presented? ? user_locale : default_locale

    locale = default_locale unless supported_locale?(locale)

    I18n.locale = locale
  end

  def user_locale
    current_user.locale
  end

  def user_presented?
    respond_to?(:user_signed_in?) && user_signed_in?
  end

  def default_locale
    request_locale || I18n.default_locale
  end

  def request_locale
    preferred_locale || compatible_locale
  end

  def preferred_locale
    http_accept_language.preferred_language_from(available_locales)
  end

  def compatible_locale
    http_accept_language.compatible_language_from(available_locales)
  end

  def available_locales
    I18n.available_locales
  end

  def supported_locale?(locale)
    available_locales.include?(locale.to_sym)
  end
end
