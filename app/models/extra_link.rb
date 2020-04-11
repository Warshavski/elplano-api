# frozen_string_literal: true

# ExtraLink
#
#   Used to represent extra links to the external resources
#
class ExtraLink
  include StoreModel::Model

  attribute :description, :string
  attribute :url, :string

  validates :url, presence: true, url: true
end
