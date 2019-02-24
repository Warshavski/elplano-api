# frozen_string_literal: true

module Users
  # Users::Gravatar
  #
  #   Used to generate gravatar in case if avatar is not set
  #
  class Gravatar
    attr_reader :gravatar_config
    attr_reader :elplano_config

    # Generate gravatar URL
    #
    # @param [Hash] params - Parameters are required to create
    #
    # @option params [String]   :email    - Used to calculate hash for the image
    # @option params [Integer]  :size     - (optional, default = 40) Used to specify image size
    # @option params [Integer]  :scale    - (optional, default = 2) Used to specify image scale
    # @option params [String]   :username - (optional, default = nil) Used to calculate hash for the image
    #
    # @return [String]
    #
    def self.call(params)
      scale = params.fetch(:scale) { 2 }

      new.execute(params[:email], params[:size], scale, username: params[:username])
    end

    def initialize
      @gravatar_config = Elplano.config.gravatar
      @elplano_config = Elplano.config.core
    end

    # Generate gravatar URL
    #
    # @param [String] email -
    #   Used to calculate hash for the image
    #
    # @param [Integer] size -
    #   (optional, default = 40) Used to specify image size
    #
    # @param [Integer] scale -
    #   (optional, default = 2) Used to specify image scale
    #
    # @param [String] username -
    #   (optional, default = nil) Used to calculate hash for the image
    #
    # @return [String]
    #
    def execute(email, size = nil, scale = 2, username: nil)
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
