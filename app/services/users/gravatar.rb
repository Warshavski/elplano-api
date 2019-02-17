# frozen_string_literal: true

module Users
  # Users::Gravatar
  #
  #   Used to generate gravatar in case if avatar is not set
  #
  class Gravatar
    attr_reader :gravatar_config
    attr_reader :elplano_config

    def initialize
      @gravatar_config = Elplano.config.gravatar
      @elplano_config = Elplano.config.core
    end

    def generate(email, size = nil, scale = 2, username: nil)
      identifier = email.presence || username.presence
      return unless identifier

      hash = Digest::MD5.hexdigest(identifier.strip.downcase)
      size = 40 unless size&.positive?

      format resolve_gravatar_url,
             hash: hash,
             size: size * scale,
             email: encode(email),
             username: encode(username)
    end

    private

    def resolve_gravatar_url
      ssl_enabled? ? gravatar_config['ssl_url'] : gravatar_config['plain_url']
    end

    def ssl_enabled?
      elplano_config['https']
    end

    def encode(text)
      ERB::Util.url_encode(text&.strip || '')
    end
  end
end
