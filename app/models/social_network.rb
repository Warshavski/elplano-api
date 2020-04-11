# frozen_string_literal: true

# SocialNetwork
#
#   Used to represent social network link
#
class SocialNetwork
  include StoreModel::Model

  attribute :network, :string
  attribute :url, :string

  validates :network, presence: true
  validates :url, presence: true, url: true
end
