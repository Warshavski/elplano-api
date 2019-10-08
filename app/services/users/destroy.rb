# frozen_string_literal: true

module Users
  # Users::Destroy
  #
  #   Used to perform user destroy
  #
  class Destroy
    include Loggable

    # @see #execute
    def self.call(user)
      new.execute(user)
    end

    # Perform user destroy
    #
    # @param user [User] Deletable user
    #
    # @return [User] Destroyed user instance
    #
    def execute(user)
      user.destroy!.tap do |u|
        log_info("User - \"#{u.username}\" (#{u.email}) was deleted")
      end
    end
  end
end
