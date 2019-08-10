# frozen_string_literal: true

module Admin
  # Admin::UserPolicy
  #
  #   Authorization policy for admin users
  #     (admin section restrictions)
  #
  #
  class UserPolicy < ApplicationPolicy
    authorize :user

    # default rule for non matched methods
    #
    default_rule :manage?

    # Use default rule for any controller methods
    #
    alias_rule :index?, :show?, :create?, :update?, :destroy?, to: :manage?

    def manage?
      user.admin?
    end
  end
end
