# frozen_string_literal: true

# User
#
#   Represents a registered user
#
class User < ApplicationRecord
  include CaseSensible
  include Searchable

  #
  # Include default devise modules. Others available are:
  #
  #   - :timeoutable
  #   - :omniauthable
  #
  devise :database_authenticatable, :lockable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :registerable

  #
  # Virtual attribute for authenticating by either username or email
  #
  attr_accessor :login

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_one :recent_access_token, -> { order(id: :desc) },
          class_name: 'Doorkeeper::AccessToken',
          foreign_key: :resource_owner_id,
          dependent: :delete

  has_one :student, dependent: :destroy

  accepts_nested_attributes_for :student

  #
  # Validations
  #
  # NOTE:  devise :validatable above adds validations for :email and :password
  #
  validates :username, presence: true, uniqueness: true
  validates :email, confirmation: true

  scope :admins, -> { where(admin: true) }

  scope :banned,    -> { where.not(banned_at: nil) }
  scope :active,    -> { where(banned_at: nil) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  scope :by_username, ->(usernames) { iwhere(username: Array(usernames).map(&:to_s)) }

  class << self
    #
    # Devise method overridden to allow sign in with email or username
    #
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)

      return find_by(conditions) if login.nil?

      where(conditions).find_by('lower(username) = :value OR lower(email) = :value', value: login.downcase.strip)
    end

    def filter(filter_name)
      case filter_name.to_s
      when 'admins'
        admins
      when 'banned'
        banned
      when 'confirmed'
        confirmed
      else
        active
      end
    end

    # Limits the result set to users _not_ in the given query/list of IDs.
    #
    # users - The list of users to ignore. This can be an `ActiveRecord::Relation`, or an Array.
    #
    def where_not_in(users = nil)
      users ? where.not(id: users) : all
    end

    def by_login(login)
      return nil unless login

      if login.include?('@')
        unscoped.iwhere(email: login).take
      else
        unscoped.iwhere(username: login).take
      end
    end

    def find_by_username(username)
      by_username(username).take
    end

    def find_by_username!(username)
      by_username(username).take!
    end

    # Search users with the given query
    #
    # @param query [String] - The search query as a String
    #
    # @note This method uses ILIKE on PostgreSQL
    #
    # @return [ActiveRecord::Relation]
    #
    def search(query)
      return none if query.blank?

      query = query.downcase

      where(
        fuzzy_arel_match(:username, query, lower_exact_match: true)
          .or(fuzzy_arel_match(:email, query, lower_exact_match: true))
      )
    end
  end

  def banned?
    banned_at != nil
  end

  def active?
    !banned?
  end

  #
  # Devise method overridden to allow send emails in background
  #
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
