# frozen_string_literal: true

module Information
  # Information::Compose
  #
  #   Used to represent information about application
  #     (such as title, version, revision, description..)
  #
  class Compose
    APPLICATION_META = %i[
      app_contact_email
      app_contact_username
      app_title
      app_short_description
      app_description
      app_extended_description
      app_terms
    ].freeze

    delegate(*APPLICATION_META, to: ApplicationSetting)

    # (see #execute)
    def self.call
      new.execute
    end

    # Perform application information composition
    #   (version, description..)
    #
    def execute
      info = init_with_version!({})

      APPLICATION_META.each_with_object(info) do |meta_attr, memo|
        memo[meta_attr] = public_send(meta_attr)
      end
    end

    private

    def init_with_version!(info)
      info.tap do |i|
        i[:app_version] = Elplano.version
        i[:app_revision] = Elplano.revision
      end
    end
  end
end
