# frozen_string_literal: true

# AdminSetting
#
#   Settings by admin
#
class AdminSetting
  include ActiveModel::Model

  ATTRIBUTES = %i[
    app_contact_username
    app_contact_email
    app_title
    app_short_description
    app_description
    app_extended_description
    app_terms
  ].freeze

  attr_accessor(*ATTRIBUTES)

  validates :app_short_description, :app_description, html: { wrap_with: :p }
  validates :app_extended_description, :app_terms, html: true
  validates :app_contact_email, :app_contact_username, presence: true

  def initialize(attributes = {})
    super(attributes).tap { initialize_attributes }
  end

  def save
    return false unless valid?

    ATTRIBUTES.each { |attr| update_attribute(attr) }
  end

  private

  def initialize_attributes
    ATTRIBUTES.each { |attr| try_set(attr) }
  end

  def try_set(attribute)
    return unless instance_variable_get("@#{attribute}").nil?

    instance_variable_set("@#{attribute}", ApplicationSetting.public_send(attribute))
  end

  def update_attribute(attribute)
    value = instance_variable_get("@#{attribute}")

    setting = ApplicationSetting.find_or_initialize_by(var: attribute)
    setting.update(value: value)
  end
end
