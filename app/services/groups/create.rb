# frozen_string_literal: true

module Groups
  # Groups::Creator
  #
  #   Used to create new students group.
  #
  #   NOTE : owner automatically become a group member and group president.
  #
  class Create
    include Loggable

    attr_reader :owner

    # Create new group
    #
    # @param [Student] owner - Group owner(group president).
    #   A Person, who can administer the group.
    #
    # @param [Hash] params Parameters required for group creation
    #
    # @option params [String] :number - Special group identity
    # @option params [String] :title  - Human readable group identity
    #
    # @return [Group]
    #
    def self.call(owner, params)
      new(owner).execute(params)
    end

    # @param [Student] owner - Group owner(group president).
    #   A Person, who can administer the group.
    #
    def initialize(owner)
      raise ArgumentError, owner if owner.nil?

      @owner = owner
    end

    # Create new group
    #
    # @param [Hash] params Parameters required for group creation
    #
    # @option params [String] :number - Special group identity
    # @option params [String] :title  - Human readable group identity
    #
    # @return [Group]
    #
    def execute(params)
      validate_owner!(owner)

      group = ActiveRecord::Base.transaction do
        owner.update!(president: true)

        Group.create!(params) do |g|
          g.president = owner
          g.students << owner
        end
      end

      group.tap { |g| log_success(g, owner.user) }
    end

    private

    def validate_owner!(owner)
      return unless owner.president? || owner.any_group?

      raise ActiveRecord::RecordInvalid.new(owner), I18n.t('errors.messages.student.already_in_group')
    end

    def log_success(group, owner_user)
      message = "Group - \"#{group.title}\" (#{group.number}) was created by User - \"#{owner_user.username}\" (#{owner_user.email})"

      log_info(message)
    end
  end
end
