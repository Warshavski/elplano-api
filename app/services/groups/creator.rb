# frozen_string_literal: true

module Groups
  # Groups::Creator
  #
  #   Used to create new students group.
  #
  #   NOTE : owner automatically become a group member and group president.
  #
  class Creator

    # @param [Student] owner Group owner(group president).
    #   A Person, who can administer the group.
    #
    # @param [Hash] params Parameters required for group creation
    #
    # @option params [String] :number - Special group identity
    # @option params [String] :title  - Human readable group identity
    #
    # @return [Group]
    #
    def execute(owner, params)
      validate_owner!(owner)

      ActiveRecord::Base.transaction do
        owner.update!(president: true)

        Group.create!(params) do |g|
          g.president = owner
          g.students << owner
        end
      end
    end

    private

    def validate_owner!(owner)
      return unless owner.president? || owner.any_group?

      raise ActiveRecord::RecordInvalid.new(owner), 'student already has a group!'
    end
  end
end
