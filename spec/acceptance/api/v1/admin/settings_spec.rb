# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin settings' do
  explanation <<~DESC
    El Plano administration: Application settings.
    
    Settings attributes :

     - `app_contact_username` - Represents contact person's name.
     - `app_contact_email` - Represents contact person's email.
     - `app_title` - Represents application title.
     - `app_short_description` - Represents application short description(may include HTML).
     - `app_description` - Represents application description(may include HTML).
     - `app_extended_description` - Represents application extended description(HTML).
     - `app_terms` - Represents application terms of use(HTML).
  DESC

  let(:user)  { create(:user) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  put 'api/v1/admin/settings' do
    with_options scope: %i[data attributes] do
      parameter :app_contact_username, "Contact person's name", required: true
      parameter :app_contact_email, "Contact person's email", required: true
      parameter :app_title, 'Application title'
      parameter :app_short_description, 'Application short description(may include HTML)'
      parameter :app_description, 'Application description(may include HTML)'
      parameter :app_extended_description, 'Application extended description(HTML)'
      parameter :app_terms, 'Application terms of use(HTML)'
    end

    let(:raw_post) do
      { data: build(:admin_setting_params) }.to_json
    end

    example 'UPDATE : Updates application settings' do
      explanation <<~DESC
        Updates application settings.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'Changes successfully saved!'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
