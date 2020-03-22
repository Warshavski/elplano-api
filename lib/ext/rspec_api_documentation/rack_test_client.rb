# frozen_string_literal: true

module RspecApiDocumentation
  # RspecApiDocumentation::RackTestClient
  #
  #   Monkey patch to prevent JSON::ParserError in documentation
  #
  #   https://github.com/zipmark/rspec_api_documentation/issues/456
  #   https://github.com/jejacks0n/apitome/issues/114
  #
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode('utf-8')
    end
  end
end
