# frozen_string_literal: true

module Timeliness
  # Timeliness::Converter
  #
  #   Used to validate time(timeline) values
  #
  class Converter
    DEFAULT_TIMEZONE = :utc

    RESTRICTION_SHORTHAND_SYMBOLS = {
      now: proc { Time.current },
      today: proc { Date.current }
    }.freeze

    attr_reader :type, :format

    def initialize(type:, format: nil, time_zone_aware: false)
      @type = type
      @format = format
      @time_zone_aware = time_zone_aware
    end

    def type_cast_value(value)
      return nil if value.nil? || !value.respond_to?(:to_time)

      value = value.in_time_zone if value.acts_like?(:time) && time_zone_aware?

      resolve_value_by_type(value)
    end

    def resolve_value_by_type(value)
      case type
      when :date
        value.to_date
      when :datetime
        value.is_a?(Time) ? value : value.to_time
      else
        value
      end
    end

    def evaluate(value, scope = nil)
      case value
      when Time, Date
        value
      when String
        parse(value)
      when Symbol
        if !scope.respond_to?(value) && restriction_shorthand?(value)
          RESTRICTION_SHORTHAND_SYMBOLS[value].call
        else
          evaluate(scope.send(value))
        end
      when Proc
        result = value.arity > 0 ? value.call(scope) : value.call

        evaluate(result, scope)
      else
        value
      end
    end

    def restriction_shorthand?(symbol)
      RESTRICTION_SHORTHAND_SYMBOLS.keys.include?(symbol)
    end

    def parse(value)
      return nil if value.nil?

      time_zone_aware? ? Time.zone.parse(value) : value.to_time(DEFAULT_TIMEZONE)
    rescue ArgumentError, TypeError
      nil
    end

    def time_zone_aware?
      @time_zone_aware
    end
  end
end
