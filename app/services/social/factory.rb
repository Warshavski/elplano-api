# frozen_string_literal: true

module Social
  # Social::Factory
  #
  #   Used to fabricate social auth services
  #
  class Factory
    PROVIDERS = HashWithIndifferentAccess.new(
      google: Social::Google::Auth,
      vk: Social::Vk::Auth,
      yandex: Social::Yandex::Auth,
      facebook: Social::Facebook::Auth
    ).freeze

    def self.call(provide_type)
      new.fabricate(provide_type)
    end

    def fabricate(provider_type)
      check_args!(provider_type)
      check_presence!(provider_type).then { PROVIDERS[provider_type] }
    end

    private

    def check_args!(*args)
      args.each { |a| raise Api::ArgumentMissing, a if a.nil? }
    end

    def check_presence!(provider_type)
      raise Api::ArgumentMissing, provider_type unless PROVIDERS.key?(provider_type)
    end
  end
end
