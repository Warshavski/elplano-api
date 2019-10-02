# frozen_string_literal: true

module Attachments
  # Attachments::Compose
  #
  #   Used to create attachments
  #
  class Create

    # @see #execute
    def self.call(author, model, attachment_data)
      new.execute(author, model, attachment_data)
    end

    # Perform attachments creation
    #
    # @param author [User]
    #   Attachments uploader
    #
    # @param model [ApplicationRecord]
    #   Application model for which attachments are created
    #
    # @param attachments_data [Array<String>]
    #   Attachments metadata such as storage, type, size, name, location
    #     (used by attachment uploader to store attachment in the storage)
    #
    def execute(author, model, attachments_data)
      return if attachments_data.blank?

      attachments_data.each_with_object([]) do |data, memo|
        compose_attributes(author, model, data).tap do |attributes|
          memo << Attachment.create!(attributes)
        end
      end
    end

    private

    def compose_attributes(author, model, data)
      {
        author: author,
        attachable_id: model.id,
        attachable_type: model.class.name,
        attachment: data
      }
    end
  end
end
