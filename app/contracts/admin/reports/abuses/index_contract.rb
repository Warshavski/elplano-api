# frozen_string_literal: true

module Admin
  module Reports
    module Abuses
      # Admin::Reports::Abuses::IndexContract
      #
      #   Used to validate filters for abuse reports list in admin section
      #
      class IndexContract < FilterContract
        params do
          optional(:user_id).type(:integer).filled(:int?)

          optional(:reporter_id).type(:integer).filled(:int?)
        end
      end
    end
  end
end
