# frozen_string_literal: true

module Groups
  # Groups::Destroy
  #
  #   [DESCRIPTION]
  #
  class Destroy
    include Loggable

    def self.call(group, actor)
      new.execute(group, actor)
    end

    # Perform group delete
    #
    # @param group [Group]
    # @param actor [User]
    #
    # @return [Group]
    #
    def execute(group, actor)
      group.destroy!.tap { |g| log_success(g, actor) }
    end

    private

    def log_success(group, actor)
      message = "Group - \"#{group.title}\" (#{group.number}) was deleted by User - \"#{actor.username}\" (#{actor.email})"

      log_info(message)
    end
  end
end
