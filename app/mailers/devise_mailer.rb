# frozen_string_literal: true

# DeviseMailer
#
#   Used as to redefine from section for devise mails
#
class DeviseMailer < Devise::Mailer
  default template_path: 'devise/mailer'

  # If devise uses default mailer this code throws an error
  default from:     -> { default_sender_address.format }
  default reply_to: -> { default_reply_to_address.format }
end
