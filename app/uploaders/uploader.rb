# frozen_string_literal: true

# Uploader
#
#   Used as base uploader class
#
class Uploader < Shrine
  #
  # Generates a more organized directory structure on the storage.
  #
  # https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/pretty_location.md#readme
  #
  plugin :pretty_location

  #
  # Define validations
  # For a complete list of all validation helpers, see AttacherMethods.
  #
  # http://shrinerb.com/rdoc/classes/Shrine/Plugins/ValidationHelpers/AttacherMethods.html
  #

  Attacher.promote_block do
    UploadProcessors::PromoteWorker
      .perform_async(self.class.name, record.class.name, record.id, name, file_data)
  end

  Attacher.destroy_block do
    UploadProcessors::DeleteWorker
      .perform_async(self.class.name, data)
  end
end
