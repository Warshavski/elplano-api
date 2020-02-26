# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin groups' do
  explanation <<~DESC
    El Plano administration: Groups.
    
    Group attributes: 

      - `title` - Human readable group identity.
      - `number` - Main group identity.
      - `timestamps`

    Users attributes :

      - `email` - Represents email that was used to register a user in the application(unique in application scope).
      - `username` - Represents used's user name.
      - `admin` - `false` if regular user `true`, if the user has access to application settings.
      - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
      - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
      - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
      - `avatar` - Represents user's avatar.
      - `timestamps`

    Student attributes :
  
      - `full_name` - Represents concatenated student's first, last and middle names.
      - `email` - Represents email which is used to contact with the student.
      - `phone` - Represents phone which is used to contact with the student.
      - `about` - Represents some detailed information about student(BIO).
      - `social_networks` - Represents a list of social networks.
      - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
      - `birthday` - Represents student's date of birth.
      - `gender` - Represents student's gender (Male, Female, Other).
      - `timestamps`
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

      expected_body = Admin::GroupCoreSerializer
                        .new([group], include: %i[president.user])
                        .serialized_json

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

      expected_body = Admin::GroupDetailedSerializer
                        .new(group, include: %i[president.user students.user])
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
