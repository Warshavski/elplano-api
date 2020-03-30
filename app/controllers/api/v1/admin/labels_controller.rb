# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::LabelsController
      #
      #   Used to manage labels groups labels
      #
      class LabelsController < ApplicationController
        specify_title_header 'Labels'

        specify_serializers default: LabelSerializer

        # GET : api/v1/labels
        #
        #   optional filter parameters :
        #
        #     - search - Filter by search term(title, description)
        #
        # @see #filter_params
        #
        # Get filtered list of labels across oll groups
        #
        def index
          render_collection filter_labels(filter_params), status: :ok
        end

        # GET : api/v1/labels/{:id}
        #
        # Get information about requested label
        #
        def show
          render_resource find_label!(params[:id]), status: :ok
        end

        private

        def find_label!(label_id)
          filter_labels.find(label_id)
        end

        def filter_labels(filters = {})
          LabelsFinder.call(params: filters)
        end

        def label_params
          params.require(:label).permit(:title, :description, :color)
        end
      end
    end
  end
end
