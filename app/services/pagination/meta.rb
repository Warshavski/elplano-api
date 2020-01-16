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
    attr_reader :limit, :page, :total_pages, :filters

    def initialize(request, resources, opts = {})
      @url = "#{request.base_url}#{request.path}"

      @filters = opts.dup
      @total_pages = resources.total_pages

      @page   = (filters.delete(:page) || Paginatable::DEFAULT_PAGE).to_i
      @limit  = (filters.delete(:limit) || Paginatable::DEFAULT_LIMIT).to_i
    end

    def call
      @metadata = nil

      metadata.tap do
        gen_self
        gen_first_prev if page > Paginatable::DEFAULT_PAGE
        gen_next_last if page < total_pages
      end
    end

    private

    def gen_self
      metadata[:links][:self] = generate_url(page)
    end

    def gen_first_prev
      metadata[:links][:first] = generate_url(Paginatable::DEFAULT_PAGE)
      metadata[:links][:prev] = generate_url(page - 1)
    end

    def gen_next_last
      metadata[:links][:next] = generate_url(page + 1)
      metadata[:links][:last] = generate_url(total_pages)
    end

    def metadata
      @metadata ||= {
        links: {},
        meta: {
          current_page: @page,
          total_pages: @total_pages
        }
      }
    end

    def generate_url(page)
      [url, url_params(page)].reject(&:blank?).join('?')
    end

    def url_params(page)
      { limit: limit, page: page }.merge(filters).to_query
    end
  end
end
