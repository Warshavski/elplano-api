# frozen_string_literal: true

module Pagination
  # Pagination::Meta
  #
  #   Used to generate metadata for paginated responses
  #
  #   NOTE : used only for offset pagination
  #
  #   TODO : add meta generation for cursor-based pagination
  #
  class Meta
    attr_accessor :url

    attr_reader :size, :number, :total_pages, :filter

    # see #execute
    #
    def self.call(request, collection, opts = {})
      new(request, collection, opts).execute
    end

    # @param request [] -
    #   Object that represents all information about endpoint request
    #
    # @param collection [ActiveRecord::Relation] -
    #   Collection of the paginated resource objects
    #
    # @param opts [Hash] - (optional, default: {}) filter and sort parameters
    #
    def initialize(request, collection, opts = {})
      @url = "#{request.base_url}#{request.path}"

      @filter = opts.without(:page)
      @total_pages = collection.total_pages

      @number = (opts.dig(:page, :number) || Paginatable::DEFAULT_PAGE_NUMBER).to_i
      @size   = (opts.dig(:page, :size)   || Paginatable::DEFAULT_PAGE_SIZE).to_i
    end

    # Perform metadata build
    #
    # @return meta [Hash] - Pagination metadata
    #
    # @option meta [Hash] :links -
    #   Urls for current, previous, next, first and last chunks
    #
    # @option meta [Hash] :meta -
    #   Current number number and total pages counter
    #
    def execute
      @metadata = nil

      metadata.tap do
        gen_self
        gen_first_prev if number > Paginatable::DEFAULT_PAGE_NUMBER
        gen_next_last if number < total_pages
      end
    end

    private

    def gen_self
      metadata[:links][:self] = generate_url(number)
    end

    def gen_first_prev
      metadata[:links][:first] = generate_url(Paginatable::DEFAULT_PAGE_NUMBER)
      metadata[:links][:prev] = generate_url(number - 1)
    end

    def gen_next_last
      metadata[:links][:next] = generate_url(number + 1)
      metadata[:links][:last] = generate_url(total_pages)
    end

    def metadata
      @metadata ||= {
        links: {},
        meta: {
          current_page: @number,
          total_pages: @total_pages
        }
      }
    end

    def generate_url(number)
      [url, url_params(number)].reject(&:blank?).join('?')
    end

    def url_params(number)
      { page: { size: size, number: number } }.merge(filter).to_query
    end
  end
end
