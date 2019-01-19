# frozen_string_literal: true

# Elplano
#
#   Used for the core app settings
#
#     - version | revision
#     - settings
#
module Elplano

  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end

  def self.migrations_hash
    @_migrations_hash ||= Digest::MD5.hexdigest(ActiveRecord::Migrator.get_all_versions.to_s)
  end

  def self.revision
    path = root.join('REVISION')

    @_revision ||=
      if File.exist?(path)
        begin
          File.read(path).strip.freeze
        rescue EOFError
          'Unknown'
        end
      else
        'Unknown'
      end
  end

  def self.version
    File.read(root.join('VERSION')).strip.freeze
  end
end
