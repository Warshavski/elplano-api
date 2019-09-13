# frozen_string_literal: true

module Uploads
  # Uploads::Create
  #
  #   Used to upload and store uploaded file in the cache storage
  #
  class Cache
    attr_reader :upload_type

    # Upload file to temporary storage and return information about an uploaded file(like URL and meta)
    #
    # @param [Hash] params -
    #   The parameters that determine file and uploader type
    #
    # @option params [ActionDispatch::Http::UploadedFile] :file - The file which needs to be uploaded
    # @option params [Symbol, String]                     :type - Type of the uploader which is used to process the file
    #
    # @raise [Api::ArgumentMissing] error on invalid input(nil params)
    #
    def self.call(params)
      new(params[:type]).execute(params[:file])
    end

    # @param [Symbol, String] upload_type -
    #   Type of the uploader which is used to process the file
    #
    def initialize(upload_type)
      check_args!(upload_type)

      @upload_type = upload_type.to_sym
    end

    # Upload file to temporary storage and return information about an uploaded file(like URL and meta)
    #
    # @param [File] file - The file which needs to be uploaded
    #
    # @return [Shrine::UploadedFile]
    #
    def execute(file)
      check_args!(file)

      uploader = resolve_uploader

      uploader.upload(file)
    end

    private

    def check_args!(*args)
      args.each { |a| raise Api::ArgumentMissing, a if a.nil? }
    end

    def resolve_uploader
      UploaderFactory.fabricate(upload_type, :cache)
    end
  end
end
