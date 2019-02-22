# UploaderFactory
#
#   Used to initialize uploader with proper storage
#
class UploaderFactory
  TYPES = { avatar: AvatarUploader }.freeze

  class << self
    # Create new uploader instance
    #
    # @param [Symbol] uploader_type -
    #   Type of the uploader(Shrine subclass defined in "uploaders" folder)
    #
    # @param [Symbol] storage_type -
    #   Type of storage in which the file will be loaded
    #
    # @raise [Elplano::Errors::ArgumentMissing] error on invalid input(nil, not existed uploader)
    #
    # @return [Shrine] uploader instance
    #
    def fabricate(uploader_type, storage_type)
      check_args!(uploader_type, storage_type)
      check_presence!(uploader_type)

      TYPES[uploader_type].new(storage_type)
    end

    private

    def check_args!(*args)
      args.each { |a| raise Elplano::Errors::ArgumentMissing, a if a.nil? }
    end

    def check_presence!(uploader_type)
      return if TYPES.key?(uploader_type)

      raise Elplano::Errors::ArgumentMissing, uploader_type
    end
  end
end

