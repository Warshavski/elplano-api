# UploaderFactory
#
#   Used to initialize uploader with proper storage
#
class UploaderFactory
  UPLOADERS = HashWithIndifferentAccess.new(
    avatar: AvatarUploader,
    attachment: AttachmentUploader
  ).freeze

  class << self
    # Create new uploader instance
    #
    # @param [Symbol] uploader_type -
    #   Type of the uploader(Shrine subclass defined in "uploaders" folder)
    #
    # @param [Symbol] storage_type -
    #   Type of storage in which the file will be loaded
    #
    # @raise [Api::ArgumentMissing] error on invalid input(nil, not existed uploader)
    #
    # @return [Shrine] uploader instance
    #
    def fabricate(uploader_type, storage_type)
      check_args!(uploader_type, storage_type)
      check_presence!(uploader_type)

      UPLOADERS[uploader_type].new(storage_type)
    end

    private

    def check_args!(*args)
      args.each { |a| raise Api::ArgumentMissing, a if a.nil? }
    end

    def check_presence!(uploader_type)
      return if UPLOADERS.key?(uploader_type)

      raise Api::ArgumentMissing, uploader_type
    end
  end
end

