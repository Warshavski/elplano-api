# frozen_string_literal: true

module JsonApi
  # JsonApi::RestifyParams
  #
  #   JSON:API support for StrongParameters
  #
  #   TODO : REFACTOR ASAP!
  #
  module RestifyParams
    extend ActiveSupport::Concern

    # Transform a JSON API document, containing a single data object,
    # into a ActionController::Parameters that is ready for ActiveRecord::Base.new() and such.
    #
    # @example
    #     data: {
    #       id: 1,
    #       type: 'post',
    #       attributes: {
    #         title: 'Title 1',
    #         description: 'wat description'
    #       },
    #       relationships: {
    #         author: {
    #           data: {
    #             type: 'author',
    #             id: 2
    #           }
    #         }
    #         comments: {
    #           data: [{
    #             type: 'comment',
    #             id: 3
    #           },{
    #             type: 'comment',
    #             id: 4
    #           }]
    #         }
    #       }
    #     }
    #
    #   restify_param(document) #=>
    #     # {
    #     #   title: 'Title 1',
    #     #   description: 'wat description',
    #     #   author_id: 2,
    #     #   comment_ids: [3, 4]
    #     # }
    #
    def restify_param(param_key)
      ActionController::Parameters.new(param_key => restify_data(param_key))
    end

    private

    def restify_data(_param_key, value = params)
      value = preprocess_params(value)

      new_params = ActionController::Parameters.new

      #
      # process relationships
      #
      if value.key?(:relationships)
        value.delete(:relationships).each do |rel_name, rel_data|
          new_data = restify_relationship(rel_name, rel_data)
          new_params.merge!(new_data.to_h) if new_data.present?
        end
      end

      #
      # process attributes
      #
      attributes = value.key?(:attributes) ? value[:attributes] : value
      attributes[:id] = value[:id] if value[:id]
      attributes.transform_keys!(&:underscore)
      new_params.merge!(attributes.to_unsafe_h)
    end

    def restify_relationship(relationship_name, relationship_data)
      if data_present?(relationship_data[:data]) && relationship_data[:data].is_a?(Array)
        restify_has_many(relationship_name, relationship_data)
      elsif relationship_data.present? && relationship_data.key?(:data)
        restify_belongs_to(relationship_name, relationship_data)
      end
    end

    def restify_has_many(rel_name, rel_data)
      if rel_data[:data].detect { |d| d[:attributes] || d[:relationships] }
        relationship_key = "#{rel_name.to_s.underscore}_attributes"

        rel = rel_data[:data].each_with_object([]) do |vv, relationship|
          relationship.push(restify_data(rel_name, vv))
        end

        { relationship_key => rel }
      else
        relationship_key = "#{rel_name.to_s.singularize.underscore}_ids"

        rel = rel_data[:data].each_with_object([]) do |vv, relationship|
          relationship.push(vv[:id])
        end

        { relationship_key => rel }
      end
    end

    def restify_belongs_to(rel_name, rel_data)
      if rel_data[:data].present? && rel_data[:data].values_at(:attributes, :relationships).compact.length.positive?
        { "#{rel_name.to_s.underscore}_attributes" => restify_data(rel_name, rel_data[:data]) }
      else
        if rel_data[:data].nil? || rel_data[:data].empty?
          { "#{rel_name.underscore}_id" => nil }
        else
          { "#{rel_name.underscore}_id" => rel_data[:data][:id] }
        end
      end
    end

    def preprocess_params(value)
      value = params.clone[:data] if value == params

      ensure!(value, :data)
      ensure!(value.key?(:type), :type)
      ensure!(value.key?(:attributes), :attributes)

      value.delete(:type)

      value
    end

    def ensure!(condition, type)
      message = I18n.t('restify.errors.missing', key: type)

      raise ActionController::ParameterMissing, message unless condition
    end

    def data_present?(data)
      data.is_a?(Array) || data.present?
    end
  end
end
