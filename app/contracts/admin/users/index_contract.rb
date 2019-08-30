# frozen_string_literal: true

module Admin
  module Users
    # Admin::Users::IndexContract
    #
    #   Used to validate filters for users list in admin section
    #
    class IndexContract < FilterContract
      params do
        optional(:status).filled(:str?, included_in?: User::STATUSES)
      end
    end
  end
end
