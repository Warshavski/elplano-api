# frozen_string_literal: true

module Admin
  module Activity
    module Events
      # Admin::Activity::Events::IndexContract
      #
      #   Used to validate filters for activity events list
      #
      class IndexContract < ::Activity::Events::IndexContract
        params do
          optional(:author_id).filled(:int?)
        end
      end
    end
  end
end
