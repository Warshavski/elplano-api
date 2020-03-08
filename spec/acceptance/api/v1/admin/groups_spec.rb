# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin groups' do
  explanation <<~DESC
    El Plano administration: Groups.
    
    #{Descriptions::Model.group}

    #{Descriptions::Model.user}

    #{Descriptions::Model.student}
  DESC

  let_it_be(:user)  { create(:admin, :student) }
  let_it_be(:token) { create(:token, resource_owner_id: user.id).token }

  let_it_be(:authorization) { "Bearer #{token}" }

  let_it_be(:students)  { [create(:student)] }
  let_it_be(:group)     { create(:group, president: user.student, students: students) }
  let_it_be(:id)        { group.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/groups' do
    example 'INDEX : Retrieve a list of student groups' do
      explanation <<~DESC
        Returns a list of the students groups.

        <b>OPTIONAL FILTERS</b> :

        - `"search": "part_of_the_title_or_number"` - Returns groups found by provided search term(title, number).

        Example: 

        <pre>
        {
          "filters": {
            "search": "group_title_or_number"
          }
        }
        </pre>

        <b>MORE INFORMATION</b> :

          - See descriptions attributes description in the section description.
          - See "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
          - By default, this endpoint returns users without status assumptions.
          - By default, this endpoint returns users limited by 15.
          - Also, includes information about group president(relation to the president model)
      DESC

      do_request

      expected_body = Admin::GroupSerializer
                        .new([group], include: %i[president.user])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/groups/:id' do
    example 'SHOW : Retrieve information about requested group' do
      explanation <<~DESC
        Returns a single instance of the group.

        <b>MORE INFORMATION</b> :

          - See descriptions attributes description in the section description.

        <b>NOTES</b> :

          - Also, includes information about group president(relation to the president model)
          - Also, includes information about group members(relation to the students descriptions)
      DESC

      do_request

      expected_body = Admin::GroupSerializer
                        .new(group, include: %i[president.user students.user])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
