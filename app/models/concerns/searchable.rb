# frozen_string_literal: true

# Searchable
#
#   Provides additions for search implementation
#
module Searchable
  extend ActiveSupport::Concern

  MIN_CHARS_FOR_PARTIAL_MATCHING = 3
  REGEX_QUOTED_WORD = /(?<=\A| )"[^"]+"(?= |\z)/.freeze

  # Search methods
  #
  module ClassMethods
    # Prepare and return query for partial search
    #
    # @param [String] query -
    #   String query that used in partial search
    #
    # @return [String] Sanitized query
    #
    def to_pattern(query)
      sanitized_query = sanitize_sql_like(query)

      if partial_matching?(query)
        "%#{sanitized_query}%"
      else
        sanitized_query
      end
    end

    # Perform fuzzy matching by the given query against given column
    #
    # @param [String] query
    #   The text to search for.
    #
    # @param [Array<String>, Array<Symbol>] columns
    #   The columns names to search in.
    #
    def fuzzy_search(query, columns)
      return none if query.blank?

      where(compose_matchers(columns, query).reduce(:or))
    end

    # Perform fuzzy matching by the given query against given column
    #
    # @param [String, Symbol] column -
    #   The column name to search in.
    #
    # @param [String] query -
    #   The text to search for.
    #
    # @param [Boolean] lower_exact_match -
    #   (optional, default: false)
    #   When set to `true`  we'll fall back to using
    #   `LOWER(column) = query` instead of using `ILIKE`.
    #
    def fuzzy_arel_match(column, query, lower_exact_match: false)
      term = query.squish
      return nil if term.blank?

      words = select_fuzzy_words(term)

      if words.any?
        words_match(column, words)
      elsif lower_exact_match
        #
        # No words of at least 3 chars, but we can search for an exact
        # case insensitive match with the query as a whole
        #
        term_exact_match(column, term)
      else
        term_like_match(column, term)
      end
    end

    def select_fuzzy_words(query)
      quoted_words = query.scan(REGEX_QUOTED_WORD)

      term = quoted_words.reduce(query) { |q, quoted_word| q.sub(quoted_word, '') }

      quoted_words.map! { |quoted_word| quoted_word[1..-2] }

      words = term.split.concat(quoted_words)

      words.select(&method(:partial_matching?))
    end

    private

    def compose_matchers(columns, query)
      columns.each_with_object([]) do |col, matchers|
        matcher = fuzzy_arel_match(col, query)

        matchers << matcher unless matcher.nil?
      end
    end

    def sanitize_sql_like(string, escape_character =  '\\')
      pattern = Regexp.union(escape_character, '%', '_')

      string.gsub(pattern) { |x| [escape_character, x].join }
    end

    def partial_matching?(query)
      query.length >= MIN_CHARS_FOR_PARTIAL_MATCHING
    end

    def words_match(column, words)
      words.map { |word| arel_table[column].matches(to_pattern(word)) }.reduce(:and)
    end

    def term_exact_match(column, term)
      Arel::Nodes::NamedFunction.new('LOWER', [arel_table[column]]).eq(term)
    end

    def term_like_match(column, term)
      arel_table[column].matches(sanitize_sql_like(term))
    end
  end
end
