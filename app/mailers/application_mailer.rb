# frozen_string_literal: true

# ApplicationMailer
#
#   Used as base class for all mailers
#
class ApplicationMailer < ActionMailer::Base
  attr_accessor :current_user

  # If case of devise usage lambda defined with optional argument
  default from:     ->(_) { default_sender_address.format }
  default reply_to: ->(_) { default_reply_to_address.format }

  private

  def default_sender_address
    email_address(core_config['email_from'], core_config['email_display_name'])
  end

  def default_reply_to_address
    email_address(core_config['email_reply_to'], core_config['email_display_name'])
  end

  def email_address(email, display_name)
    Mail::Address.new("#{display_name} <#{email}>")
  end

  def core_config
    @core_config ||= Elplano.config.core
  end
end
