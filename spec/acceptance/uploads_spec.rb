# frozen_string_literal: true

require 'acceptance_helper'

resource 'Uploads' do
  explanation <<~DESC
    El Plano file uploads API.

    Uploaded file metadata attributes :

      - `id` - Represents unique uploaded file identity.
      - `storage` - Represents file storage type.
      - `metadata` - Represents uploaded file metadata(name, size, e.t.c.).
        - `filename` - Represents name of the uploaded file.
        - `size` - Represents size of the uploaded file(bytes).
        - `mime_type` - Represents MIME(Multipurpose Internet Mail Extensions or MIME) type of the uploaded file.

  DESC

  let(:user) { create(:user, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:file)    { fixture_file_upload('spec/fixtures/files/dk.png') }
  let(:type)    { :avatar }

  let(:file_attributes) do
    {
      id: '344f98a5e8c879851116c54e9eb5e610.jpg',
      storage: 'cache',
      metadata: {
        filename: 'dk.png',
        size: 1_062,
        mime_type: 'image/png'
      }
    }
  end

  before do
    allow(Uploads::Cache).to receive(:call).and_return(file_attributes)
  end

  post 'uploads' do
    with_options scope: :upload do
      parameter :type, 'Uploader type', required: true
      parameter :file, 'The file that needs to be uploaded', required: true
    end

    let(:raw_post) do
      {
        upload: {
          type: type,
          file: file
        }
      }.to_json
    end

    example "CREATE : Upload file" do
      explanation <<~DESC
        Returns uploaded file identity and its metadata
      DESC

      do_request

      expect(status).to eq(201)
      expect(response_body).to eq(file_attributes.to_json.to_s)
    end
  end
end
