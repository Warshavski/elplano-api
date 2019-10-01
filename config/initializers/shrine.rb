require 'shrine'
require 'shrine/plugins/activerecord'
require 'shrine/plugins/backgrounding'
require 'shrine/plugins/delete_promoted'
require 'shrine/plugins/delete_raw'
require 'shrine/plugins/logging'
require 'shrine/plugins/determine_mime_type'
require 'shrine/plugins/cached_attachment_data'
require 'shrine/plugins/restore_cached_data'
require 'shrine/plugins/validation_helpers'
require 'shrine/plugins/pretty_location'

#
# Provides ActiveRecord integration, adding callbacks and validations.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/activerecord.md#readme
#
Shrine.plugin :activerecord

#
# Adds the ability to put storing and deleting into a background job.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/backgrounding.md#readme
#
Shrine.plugin :backgrounding

#
# Adds a convenient model method for the hidden form cache field.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/cached_attachment_data.md#readme
#
Shrine.plugin :cached_attachment_data

#
# Determine the actual MIME type from file contents.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/determine_mime_type.md#readme
#
Shrine.plugin :determine_mime_type

Shrine.plugin :instrumentation

Shrine.logger = Rails.logger

#
# Re-extracts cached file's metadata on model assignment.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/restore_cached_data.md#readme
#
Shrine.plugin :restore_cached_data

#
# Gives you convenient methods for validating file's metadata.
# https://github.com/shrinerb/shrine/blob/v2.16.0/doc/plugins/validation_helpers.md#readme
#
Shrine.plugin :validation_helpers

if Rails.env.development?
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('storage/uploads', prefix: 'cache'), # temporary
    store: Shrine::Storage::FileSystem.new('storage/uploads'), # permanent
  }
elsif Rails.env.test?
  require 'shrine/storage/memory'

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  require "shrine/storage/s3"

  s3_options = {
    access_key_id:      ENV['S3_ACCESS_KEY_ID'],
    secret_access_key:  ENV['S3_SECRET_ACCESS_KEY'],
    bucket:             ENV['S3_BUCKET'],
    region:             ENV['S3_REGION']
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)
  }
end
