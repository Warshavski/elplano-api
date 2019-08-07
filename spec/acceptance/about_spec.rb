# frozen_string_literal: true

require 'acceptance_helper'

resource 'About' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  let_it_be(:meta) do
    build(:admin_setting_params)[:attributes].merge({ app_version: 1, app_revision: 'rev e0f21'})
  end

  before do
    allow(Information::Compose).to receive(:call).and_return(meta)
  end

  get '/' do
    example "SHOW : Application information" do
      explanation <<~DESC
        Returns application information

        Application information meta attributes :

          - `app_version` - Represents application version.
          - `app_revision` - Represents application revision(build).
          - `app_contact_username` - Represents contact person's name.
          - `app_contact_email` - Represents contact person's email.
          - `app_title` - Represents application title.
          - `app_short_description` - Represents application short description(may include HTML).
          - `app_description` - Represents application description(may include HTML).
          - `app_extended_description` - Represents application extended description(HTML).
          - `app_terms` - Represents application terms of use(HTML).
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq({ 'meta' => meta }.to_json)
    end
  end
end
