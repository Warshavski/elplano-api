# frozen_string_literal: true

# ParamsRequirable
#
#   Used to perform required parameters presence check
#
module ParamsRequirable
  extend ActiveSupport::Concern

  class_methods do
    def required_params!(*attributes, **options)
      before_action(**options) do
        attributes.each do |key|
          value = params.dig(*[options[:scope], key].compact)

          raise ActionController::ParameterMissing, key if value.blank?
        end
      end
    end
  end
end
