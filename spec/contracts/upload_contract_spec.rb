# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadContract do
  include_context :contract_validation

  let_it_be(:file) do
    Rack::Test::UploadedFile.new(
      File.open(
        File.join(
          Rails.root, '/spec/fixtures/files/dk.png'
        )
      )
    )
  end

  let_it_be(:default_params) do
    {
      file: file,
      type: 'avatar'
    }
  end

  it_behaves_like :valid

  UploaderFactory::UPLOADERS.keys.each { |type| it_behaves_like :valid, with: { type: type } }

  it_behaves_like :invalid, without: :file
  it_behaves_like :invalid, without: :type
end
