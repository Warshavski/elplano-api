# frozen_string_literal: true

# ErrorSerializer
#
#   Used for the errors serialization
#
module ErrorSerializer
  def self.serialize(object, status)
    object.errors.messages.each_with_object([]) do |(field, errors), result|
      errors.each { |error_message| result << compose_error(field, status, error_message) }
    end
  end

  def self.compose_error(field, status, message)
    {
      status: status,
      source: { pointer: "/data/attributes/#{field}" },
      detail: message
    }
  end

  private_class_method :compose_error
end
