# frozen_string_literal: true

#
# El Plano
#
ApplicationSetting.core ||= {}

ApplicationSetting.core['relative_url_root'] ||= ENV['RAILS_RELATIVE_URL_ROOT'] || ''
ApplicationSetting.core['protocol']          ||= ApplicationSetting.core['https'] ? 'https' : 'http'
ApplicationSetting.core['base_url']          ||= ApplicationSetting.__send__(:build_base_elplano_url)

#
# Gravatar
#
ApplicationSetting.gravatar ||= {}

ApplicationSetting.gravatar['enabled'] = true if ApplicationSetting.gravatar['enabled'].nil?
ApplicationSetting.gravatar['host'] = ApplicationSetting.host_without_www(ApplicationSetting.gravatar['plain_url'])
