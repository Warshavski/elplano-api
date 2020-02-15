# frozen_string_literal: true

# AttachmentUploader
#
#   Used to upload attachments
#
class AttachmentUploader < Uploader
  MAX_SIZE = 10
  ALLOWED_TYPES = %w[application/pdf image/png].freeze

  Attacher.validate do
    validate_max_size(
      AttachmentUploader::MAX_SIZE.megabytes,
      message: I18n.t(:'uploaders.errors.too_large', size: AttachmentUploader::MAX_SIZE)
    )

    validate_mime_type_inclusion AttachmentUploader::ALLOWED_TYPES
  end
end
