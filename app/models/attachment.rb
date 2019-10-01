# frozen_string_literal: true

# Attachment
#
#   Represents uploaded files
#
class Attachment < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :author,
             class_name: 'User',
             inverse_of: :uploads,
             foreign_key: :user_id

  belongs_to :attachable, polymorphic: true
end
