# frozen_string_literal: true

# UserPolicy
#
#   Authorization policy for all users
#
class UserPolicy < ActionPolicy::Base
  authorize :user

  # default rule for non matched methods
  #
  default_rule :manage?

  # Use default rule for any controller methods
  #
  alias_rule :index?, :show?, :create?, :update?, :destroy?, to: :manage?

  def manage?
    !record.banned?
  end
end
