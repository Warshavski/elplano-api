# frozen_string_literal: true

# PasswordPolicy
#
#   A basic authorization policy for actions that require password confirmation
#
class PasswordPolicy < ApplicationPolicy
  authorize :user

  # default rule for non matched methods
  #
  default_rule :manage?

  # Use default rule for any controller methods
  #
  alias_rule :create?, :update?, :destroy?, to: :manage?

  def manage?
    user.valid_password?(record)
  end
end
