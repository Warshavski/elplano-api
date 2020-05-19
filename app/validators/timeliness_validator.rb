# frozen_string_literal: true

# TimelinessValidator
#
#   Used to validate datetime restrictions
#
class TimelinessValidator < ActiveModel::EachValidator
  attr_reader :type, :attributes, :converter

  RESTRICTIONS = {
    is_at: :==,
    before: :<,
    after: :>,
    on_or_before: :<=,
    on_or_after: :>=
  }.freeze

  DEFAULT_ERROR_VALUE_FORMATS = {
    date: '%Y-%m-%d',
    time: '%H:%M:%S',
    datetime: '%Y-%m-%d %H:%M:%S'
  }.freeze

  RESTRICTION_ERROR_MESSAGE = "Error occurred validating %s for %s restriction:\n%s"

  def self.kind
    :timeliness
  end

  def initialize(options)
    @type = options.delete(:type) || :datetime
    @allow_nil = options.delete(:allow_nil)
    @allow_blank = options.delete(:allow_blank)

    range = options.delete(:between)

    if range
      unless range.is_a?(Range) || range.is_a?(Array)
        raise ArgumentError, ':between must be a Range or an Array'
      end

      options[:on_or_after] = range.first
      if range.is_a?(Range) && range.exclude_end?
        options[:before] = range.last
      else
        options[:on_or_before] = range.last
      end
    end

    @restrictions_to_check = RESTRICTIONS.keys & options.keys

    super

    setup_validated_attributes(options[:class]) if options[:class]
  end

  def setup_validated_attributes(model)
    return unless model.respond_to?(:timeliness_validated_attributes)

    model.timeliness_validated_attributes ||= []
    model.timeliness_validated_attributes |= attributes
  end

  def validate_each(record, attr_name, value) # rubocop:disable Metrics/CyclomaticComplexity
    raw_value = attribute_raw_value(record, attr_name) || value
    return if allow_nil_or_blank?(raw_value)

    @converter = initialize_converter(record, attr_name)

    value = @converter.parse(raw_value) if value.is_a?(String) || options[:format]
    value = @converter.type_cast_value(value)

    add_error(record, attr_name, :"invalid_#{@type}") && return if value.blank?

    validate_restrictions(record, attr_name, value)
  end

  def allow_nil_or_blank?(raw_value)
    (@allow_nil && raw_value.nil?) || (@allow_blank && raw_value.blank?)
  end

  def validate_restrictions(record, attr_name, value)
    @restrictions_to_check.each do |restriction|
      restriction_value = @converter.type_cast_value(@converter.evaluate(options[restriction], record))

      next if value.send(RESTRICTIONS[restriction], restriction_value)

      add_error(record, attr_name, restriction, restriction_value)
      break
    rescue StandardError => e
      message = format(RESTRICTION_ERROR_MESSAGE, attr_name, restriction.inspect, e.message)

      add_error(record, attr_name, message) && break
    end
  end

  def add_error(record, attr_name, message, value = nil)
    value = format_error_value(value) if value

    message_options = {
      message: options.fetch(:"#{message}_message", options[:message]),
      restriction: value
    }

    record.errors.add(attr_name, message, message_options)
  end

  def format_error_value(value)
    i18n_options = {
      default: DEFAULT_ERROR_VALUE_FORMATS[@type],
      scope: 'validators.timeliness.error_value_formats'
    }

    format = I18n.t(@type, i18n_options)

    value.strftime(format)
  end

  def attribute_raw_value(record, attr_name)
    record.respond_to?(:read_timeliness_attribute_before_type_cast) &&
      record.read_timeliness_attribute_before_type_cast(attr_name.to_s)
  end

  def time_zone_aware?(record, attr_name)
    record.class.respond_to?(:skip_time_zone_conversion_for_attributes) &&
      !record.class.skip_time_zone_conversion_for_attributes.include?(attr_name.to_sym)
  end

  def initialize_converter(record, attr_name)
    Timeliness::Converter.new(
      type: @type,
      time_zone_aware: time_zone_aware?(record, attr_name),
      format: options[:format]
    )
  end
end
