# ApplicationSettings
#
#   Used to store application-wide settings(RailsSettings Model)
#
# NOTE : When config/elplano.yml has changed, you need change this prefix to v2, v3 ... to expires caches
#        cache_prefix { "v1" }
#
class ApplicationSettings < RailsSettings::Base
  source Rails.root.join('config/elplano.yml')
end
