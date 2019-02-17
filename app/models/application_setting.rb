# ApplicationSetting
#
#   Used to store application-wide settings(RailsSettings Model)
#
# NOTE : When config/elplano.yml has changed, you need change this prefix to v2, v3 ... to expires caches
#        cache_prefix { "v1" }
#
class ApplicationSetting < RailsSettings::Base
  source Rails.root.join('config/elplano.yml')

  class << self

    def host_without_www(url)
      host(url).sub('www.', '')
    end

    def host(url)
      url = url.downcase
      url = "http://#{url}" unless url.start_with?('http')

      #
      # Get rid of the path so that we don't even have to encode it
      #
      url_without_path = url.sub(%r{(https?://[^/]+)/?.*}, '\1')

      URI.parse(url_without_path).host
    end

    def build_base_elplano_url
      base_url(self.core).join('')
    end

    private

    def base_url(config)
      custom_port = on_standard_port?(config) ? nil : ":#{config['port']}"

      [
        config['protocol'],
        '://',
        config['host'],
        custom_port
      ]
    end

    def on_standard_port?(config)
      config['port'].to_i == (config['https'] ? 443 : 80)
    end
  end
end
