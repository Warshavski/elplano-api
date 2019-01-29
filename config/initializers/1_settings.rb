# frozen_string_literal: true

#
# El Plano
#
ApplicationSetting.elplano ||= {}

ApplicationSetting.elplano['relative_url_root'] ||= ENV['RAILS_RELATIVE_URL_ROOT'] || ''
ApplicationSetting.elplano['protocol']          ||= ApplicationSetting.elplano['https'] ? 'https' : 'http'
ApplicationSetting.elplano['base_url']          ||= ApplicationSetting.__send__(:build_base_elplano_url)

#
# Gravatar
#
ApplicationSetting.gravatar ||= {}

ApplicationSetting.gravatar['enabled'] = true if ApplicationSetting.gravatar['enabled'].nil?
ApplicationSetting.gravatar['host'] = ApplicationSetting.host_without_www(ApplicationSetting.gravatar['plain_url'])
