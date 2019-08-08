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
    Mail::Address.new(core_config['email_from']).tap do |address|
      address.display_name = core_config['email_display_name']
    end
  end

  def default_reply_to_address
    Mail::Address.new(core_config['email_reply_to']).tap do |address|
      address.display_name = core_config['email_display_name']
    end
  end

  def core_config
    @config ||= Elplano.config.core
  end
end
