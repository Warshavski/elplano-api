# frozen_string_literal: true

require 'acceptance_helper'

resource 'About' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  let_it_be(:meta) do
    build(:admin_setting_params).merge({ app_version: 1, app_revision: 'rev e0f21'})
  end

  before do
    allow(Information::Compose).to receive(:call).and_return(meta)
  end

  get '/' do
    example "SHOW : Application information" do
      explanation <<~DESC
        Returns application information

        #{Descriptions::Model.application_meta}
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq({ 'meta' => meta }.to_json)
    end
  end
end
