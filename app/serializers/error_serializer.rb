# frozen_string_literal: true

# ErrorSerializer
#
#   Used for the errors serialization
#
class ErrorSerializer
  def initialize(resource)
    @resource = resource
  end

  def serialize
    errors = @resource.errors

    errors.messages.each_with_object([]) do |(field, messages), result|
      messages.each do |error_message|
        result << compose_error(field, 422, error_message)
      end
    end
  end

  private

  def compose_error(attribute, status, message)
    {
      status: status,
      source: generate_source(attribute),
      detail: generate_message(attribute, message)
    }
  end

  def generate_source(attribute)
    { pointer: "/data/attributes/#{attribute}" }
  end

  def generate_message(attribute, message)
    return message if attribute == :base

    attr_name = attribute.to_s.tr('.', '_').humanize
    attr_name = @resource.class.human_attribute_name(attribute, default: attr_name)

    I18n.t(:"errors.format",
           default: '%{attribute} %{message}',
           attribute: attr_name,
           message: message)
  end
end
