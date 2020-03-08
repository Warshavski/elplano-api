# frozen_string_literal: true

# AttachmentSerializer
#
#   Used for attachment data representation
#
class AttachmentSerializer < ApplicationSerializer
  set_type :attachment

  attribute :filename do |object|
    dig_metadata(object, 'filename')
  end

  attribute :size do |object|
    dig_metadata(object, 'size')
  end

  attribute :mime_type do |object|
    dig_metadata(object, 'mime_type')
  end

  attribute :url, &:attachment_url

  attributes :created_at, :updated_at

  class << self
    private

    def dig_metadata(object, attr_name)
      object.attachment_data.dig('metadata', attr_name)
    end
  end
end
