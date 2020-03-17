# frozen_string_literal: true

# Denotable
#
#   Used to add endpoint title annotations in Endpoint-Title header
#
module Denotable
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :title_segments

    def specify_title_header(*segments)
      segments.each_with_object(title_segments) { |s, memo| memo << s }
    end

    def title_segments
      return @title_segments if already_defined?

      @title_segments = ancestor_defined? ? ancestor_segments : []
    end

    private

    def already_defined?
      instance_variable_defined?(:@title_segments)
    end

    def ancestor_defined?
      superclass.respond_to?(:title_segments)
    end

    def ancestor_segments
      superclass.title_segments.dup
    end
  end

  included do
    append_before_action :set_endpoint_title_header

    def set_endpoint_title_header
      return if self.class.title_segments.blank?

      #
      # Segments are separated by middot
      #
      title = self.class.title_segments.join(' . ')

      #
      # Per https://tools.ietf.org/html/rfc5987, headers need to be ISO-8859-1, not UTF-8
      #
      response.headers['Endpoint-Title'] = ERB::Util.url_encode(title)
    end
  end
end
