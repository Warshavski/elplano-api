# frozen_string_literal: true

# ApplicationFinder
#
#   User as base class for all finders and contains common logic
#
class ApplicationFinder
  include Paginatable
  include Sortable

  attr_reader :context, :params

  def initialize(context: nil, params: {})
    @context = context
    @params = params
  end

  def self.call(context: nil, params: {})
    new(context: context, params: params).execute
  end

  def execute
    raise NotImplementedError
  end
end
