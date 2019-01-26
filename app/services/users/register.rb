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
    attr_accessor :params

    def initialize(params = {})
      @params = params
    end

    def execute
      User.transaction do
        user = block_given? ? yield : User.new(params)
        user.save!

        Student.create!(user: user, email: user.email)

        user
      end
    end
  end
end
