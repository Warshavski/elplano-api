# frozen_string_literal: true

# AvatarUploader
#
#   Used to upload avatars
#
class AvatarUploader < Uploader
  MAX_SIZE = 5
  ALLOWED_TYPES = %w[image/jpeg image/jpg image/png].freeze

  Attacher.validate do
    validate_max_size(
      AvatarUploader::MAX_SIZE.megabytes,
      message: I18n.t(:'uploaders.errors.too_large', size: AvatarUploader::MAX_SIZE)
    )

    validate_mime_type_inclusion AvatarUploader::ALLOWED_TYPES
  end
end
