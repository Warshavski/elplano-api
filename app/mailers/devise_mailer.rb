# frozen_string_literal: true

# DeviseMailer
#
#   Used as to redefine from section for devise mails
#
class DeviseMailer < Devise::Mailer
  default template_path: 'devise/mailer'
  default from: "#{ENV['MAILER_DISPLAY_NAME']} <#{ENV['MAILER_FROM']}>"
end
