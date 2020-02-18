# frozen_string_literal: true

require 'acceptance_helper'

resource "User's classmates" do
  explanation <<~DESC
    El Plano classmates API.

    Student attributes :

      - `full_name` - Represents concatenated student's first, last and middle names.
      - `email` - Represents email which is used to contact with the student.
      - `phone` - Represents phone which is used to contact with the student.
      - `about` - Represents some detailed information about student(BIO).
      - `social_networks` - Represents a list of social networks.
      - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
      - `timestamps`
  
      Also, includes information about a user and relationships to the group and user.
  
      - `email` - Represents email that was used to register a user in the application(unique in application scope).
      - `username` - Used as user name.
      - `admin` - `false` if regular user `true`, if the user has access to application settings.
      - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
      - `avatar_url` - User's avatar URL.
      - `timestamps`
  DESC

  let(:user)  { student.user }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:student) { create(:student, :group_member) }
  let(:id) { student.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/classmates' do
    example 'INDEX : Retrieve classmates list' do
      explanation <<~DESC
        Returns a list of the users's classmates.

        <b>OPTIONAL FILTERS</b> :

        - `"search": "part_of_the_fullname_or_email"` - Returns classmates found by provided search term(email, full name or phone).

        Example: 

        <pre>
        {
          "filters": {
            "search": "wat@email_or_username"
          }
        }
        </pre>

        <b>MORE INFORMATION</b>

          - See "Filters" and "Pagination" sections in the README section.
          - See model attributes description in the section description. 

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
      DESC

      do_request

      expected_body = StudentSerializer
                        .new(student.group.students)
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/classmates/:id' do
    example "SHOW : Information about particular classmate" do
      explanation <<~DESC
        Returns a single instance of the user's classmate(detailed information).

        <b>MORE INFORMATION</b>

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = StudentSerializer
                        .new(student, include: [:user])
                        .serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
