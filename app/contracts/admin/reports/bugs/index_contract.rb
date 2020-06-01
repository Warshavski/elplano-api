# frozen_string_literal: true

module Admin
  module Reports
    module Bugs
      # Admin::Reports::Bugs::IndexContract
      #
      #   Used to validate filters for bug reports list in admin section
      #
      class IndexContract < FilterContract
        params do
          optional(:user_id).type(:integer).filled(:int?)
        end
      end
    end
  end
end
