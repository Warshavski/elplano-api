# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin labels' do
  explanation <<~DESC
    El Plano administration: Labels management API
    
    #{Descriptions::Model.label}
  DESC

  let_it_be(:admin) { create(:user, :admin) }
  let_it_be(:token) { create(:token, resource_owner_id: admin.id).token }

  let_it_be(:authorization) { "Bearer #{token}" }

  let_it_be(:student) { create(:student, :group_supervisor) }
  let_it_be(:label)   { create(:label, group: student.group) }

  let_it_be(:id) { label.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/labels' do
    example 'INDEX : Retrieve a list of labels' do
      explanation <<~DESC
        Returns a list of labels.

        <b>OPTIONAL FILTERS</b> :

        - `"search": "part_of_the_title_or_description"` - Returns labels found by provided search term(title, description).

        Example: 

        <pre>
        {
          "filters": {
            "search": "lorem.."
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See label attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTES<b> :

          - By default, this endpoint returns labels sorted by recently created.
          - By default, this endpoint returns labels limited by 15
      DESC

      do_request

      expected_body = LabelSerializer.new([label]).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/labels/:id' do
    example 'SHOW : Retrieve information about requested label' do
      explanation <<~DESC
        Returns a single instance of the label.

        <b>MORE INFORMATION</b> :
        
          - See label attributes description in the section description.
      DESC

      do_request

      expected_body = LabelSerializer.new(label).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
