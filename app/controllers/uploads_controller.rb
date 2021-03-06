# frozen_string_literal: true

# UploadsController
#
#   Used to manage file uploads(uploads file to the temporary storage)
#
class UploadsController < ApplicationController
  skip_before_action :check_request_format

  specify_title_header 'Uploads'

  # POST : uploads
  #
  # Upload and save file in cache storage
  #
  # Response body example:
  #
  # {
  #   "id": "344f98a5e8c879851116c54e9eb5e610.jpg",
  #   "storage":"cache",
  #   "metadata":{
  #     "filename":"KMZxXr_1.jpg",
  #     "size":187165,
  #     "mime_type":"image/jpeg"
  #   }
  # }
  #
  def create
    cached_file = Uploads::Cache.call(upload_params)

    render json: cached_file, status: :created
  end

  private

  def upload_params
    validate_with(UploadContract.new, params[:upload])
  end
end
