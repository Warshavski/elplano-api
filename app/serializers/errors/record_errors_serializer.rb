# frozen_string_literal: true

module Errors
  # Errors::RecordErrorsSerializer
  #
  #   Used to serializer model level validation errors
  #
  class RecordErrorsSerializer
    # @param [ApplicationRecord] - Record instance that contains any validation errors
    #
    def initialize(model, status_code)
      @model = model
      @status_code = status_code

      @relationships = fetch_relationships(model)
    end

    def to_json(*_args)
      Oj.dump(serialize)
    end

    def serialize
      serialize_model_errors(@model) + serialize_relationships_errors(@relationships)
    end

    private

    def fetch_relationships(model)
      return [] unless model.class.respond_to?(:reflect_on_all_associations)

      model.class.reflect_on_all_associations
    end

    def serialize_model_errors(model)
      errors = model.errors

      errors.messages.each_with_object([]) do |(attribute, messages), result|
        source = block_given? ? yield(attribute) : { pointer: "/data/attributes/#{attribute}" }

        messages.each do |error_message|
          result << compose_error(source, attribute, error_message, model)
        end
      end
    end

    def serialize_relationships_errors(relationships)
      relationships.each_with_object([]) do |relationship, errors|
        relationship_records = @model.public_send(relationship.name)

        next if relationship_records.nil?

        if relationship_records.respond_to?(:each)
          process_collection!(errors, relationship_records)
        else
          process_single!(errors, relationship_records)
        end
      end
    end

    def process_collection!(errors, relationship_records)
      relationship_records.each_with_index do |record, index|
        relationship_errors = serialize_model_errors(record) do |attribute|
          { pointer: "/data/attributes/#{record.model_name.plural}[#{index}].#{attribute}" }
        end

        errors.push(*relationship_errors)
      end
    end

    def process_single!(errors, record)
      model_errors = serialize_model_errors(record)

      errors.push(*model_errors)
    end

    def compose_error(source, attribute, msg, model)
      {
        status: @status_code,
        source: source,
        detail: generate_message(attribute, msg, model)
      }
    end

    def generate_message(attribute, message, resource)
      return message if attribute == :base

      attr_name = attribute.to_s.tr('.', '_').humanize
      attr_name = resource.class.human_attribute_name(attribute, default: attr_name)

      localization_options = {
        default: '%{attribute} %{message}', # rubocop:disable Style/FormatStringToken
        attribute: attr_name,
        message: message
      }

      I18n.t(:'errors.format', localization_options)
    end
  end
end
