# frozen_string_literal: true

# ExtraLink
#
#   Used to represent extra links to the external resources
#
class ExtraLink
  include StoreModel::Model

  attribute :service, :string
  attribute :url, :string

  validates :service, :url, presence: true
  validates :url, url: true
end
