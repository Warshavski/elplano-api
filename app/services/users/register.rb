# frozen_string_literal: true

module Users
  # Users::Register
  #
  #   Used to register new user
  #
  #     - creates new user from credentials
  #     - creates new student for new user
  #
  class Register
    include Loggable

    # Create(register) new user
    #
    # @param [Hash] params (optional, default = {})
    #
    # @option [String] :email -
    #   Unique email that used to identify user in system
    #
    # @option [String] :password -
    #   Password that the user uses to log in
    #
    # @option [String] :password_confirmation -
    #   Password duplicate. Used to prevent typos when entering a password
    #
    # @option [String] :username -
    #   Username(nickname) alternative user identity
    #
    # @yield - Alternative user constructor
    #
    # @return [User]
    #
    def self.call(params = {}, &block)
      new.execute(params, &block)
    end

    # Create(register) new user
    #
    # @param [Hash] params (optional, default = {})
    #
    # @option [String] :email -
    #   Unique email that used to identify user in system
    #
    # @option [String] :password -
    #   Password that the user uses to log in
    #
    # @option [String] :password_confirmation -
    #   Password duplicate. Used to prevent typos when entering a password
    #
    # @option [String] :username -
    #   Username(nickname) alternative user identity
    #
    # @yield - Alternative user constructor
    #
    # @return [User]
    #
    def execute(params, &block)
      User.transaction do
        user = block ? yield : User.new(params)

        user.save! do |u|
          Student.create!(user: u, email: u.email)
        end

        user.tap do |u|
          log_info("User - \"#{u.username}\" (#{u.email}) was registered")
        end
      end
    end
  end
end
