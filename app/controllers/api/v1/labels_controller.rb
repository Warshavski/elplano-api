# frozen_string_literal: true

module Api
  module V1
    # Api::V1::LabelsController
    #
    #   Used to manage labels created by authenticated student
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
      # Get filtered list of labels created by current_student
      #
      def index
        render_collection filter_labels(filter_params), status: :ok
      end

      # GET : api/v1/labels/{:id}
      #
      def show
        render_resource find_label!(params[:id]), status: :ok
      end

      # POST : api/v1/labels
      #
      def create
        label = current_group.labels.create!(label_params)

        render_resource label, status: :created
      end

      # PATCH/PUT : api/v1/labels/{:id}
      #
      def update
        label = find_label!(params[:id]).tap do |l|
          l.update!(label_params)
        end

        render_resource label, status: :ok
      end

      # DELETE : api/v1/labels/{:id}
      #
      def destroy
        find_label!(params[:id]).destroy!

        head :no_content
      end

      private

      def find_label!(label_id)
        filter_labels.find(label_id)
      end

      def filter_labels(filters = {})
        LabelsFinder.call(context: current_group, params: filters)
      end

      def label_params
        params.require(:label).permit(:title, :description, :color)
      end
    end
  end
end
