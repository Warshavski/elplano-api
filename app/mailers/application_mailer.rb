# frozen_string_literal: true

# ApplicationMailer
#
#   Used as base class for all mailers
#
class ApplicationMailer < ActionMailer::Base
  attr_accessor :current_user

  default from:     -> { default_sender_address.format }
  default reply_to: -> { default_reply_to_address.format }

  private

  def default_sender_address
    address = Mail::Address.new(core_config['email_from'])
    address.display_name = core_config['email_display_name']
    address
  end

  def default_reply_to_address
    address = Mail::Address.new(core_config['email_reply_to'])
    address.display_name = core_config['email_display_name']
    address
  end

  def core_config
    @config ||= Elplano.config.core
  end
end
