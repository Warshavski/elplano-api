# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.api_name = 'El Plano API'

  #
  # Output folder
  #
  config.docs_dir = Rails.root.join('documentation', 'api')

  #
  # An array of output format(s).
  # Possible values are:
  #
  #   :json
  #   :html,
  #   :combined_text,
  #   :combined_json,
  #   :json_iodocs,
  #   :textile,
  #   :markdown,
  #   :append_json
  #
  config.format = [:json]

  config.post_body_formatter = :json

  config.curl_host = 'http://localhost:3000'
end
