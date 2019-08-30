# frozen_string_literal: true

# UploadContract
#
#   Used to validate upload params
#
class UploadContract < Dry::Validation::Contract
  params do
    required(:type).value(:string, included_in?: UploaderFactory::UPLOADERS.keys)
    required(:file).filled
  end
end
