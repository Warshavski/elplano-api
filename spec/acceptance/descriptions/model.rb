module Descriptions
  class Model
    class << self
      def user
        <<~DESC
          Users attributes :

            - `email` - Represents email that was used to register a user in the application(unique in application scope).
            - `username` - Represents used's user name.
            - `admin` - `false` if regular user `true`, if the user has access to application settings.
            - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
            - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
            - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
            - `locale` - Represents user's locale.
            - `timezone` - Represents user's timezone(UTC is by default)
            - `settings` - Represents custom user settings, such as UI configuration(custom JSON)
            - `avatar_url` - Represents user's avatar.
            - `timestamps`
        DESC
      end

      def student
        <<~DESC
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
      end

      def access_token
        <<~DESC
          Token attributes :

            - `access_token` - Represents access token(used to access API endpoints).
            - `refresh_token` - Represents refresh token(used to update expired access token).
            - `token_type` - Represents token type(always "Bearer").
            - `expires_in` - Represents expiration access token expiration time.
            - `created_at` - Represents access token creation date.
        DESC
      end

      def upload_meta
        <<~DESC
          Uploaded file metadata attributes :

            - `id` - Represents unique uploaded file identity.
            - `storage` - Represents file storage type.
            - `metadata` - Represents uploaded file metadata(name, size, e.t.c.).
              - `filename` - Represents name of the uploaded file.
              - `size` - Represents size of the uploaded file(bytes).
              - `mime_type` - Represents MIME(Multipurpose Internet Mail Extensions or MIME) type of the uploaded file.
        DESC
      end

      def application_meta
        <<~DESC
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
      end

      def task
        <<~DESC
          Task attributes :
      
            - `title` - Represents task name(human readable identity).
            - `description` - Represents task description.
            - `outdated` - `true` if task is available in current time(not expired task), otherwise `false`.
            - `extra_links` - Represents links(URL) to extra attachments on external storage(Google drive, for example)
            - `expired_at` - Represents expiration time(task completion deadline).
            - `timestamps`
        DESC
      end

      def attachment
        <<~DESC
          Attachment attributes :
      
            - `filename` - Represents original file name.
            - `size` - Represents file size(bytes).
            - `mime_type` - Represents file type(https://www.freeformatter.com/mime-types-list.html).
            - `url` - Represents url to download file.
            - `timestamps`
        DESC
      end

      def event
        <<~DESC
          Event attributes :
      
           - `title` - Represents event name.
           - `description` - Represents event detailed description.
           - `status` - Represents event current status.
             - `confirmed` - The event is confirmed. This is the default status.
             - `tentative` - The event is tentatively confirmed.
             - `cancelled` - The event is cancelled (deleted).
        
           - `recurrence` - Represents recurrence rules.
           - `timezone` - Timezone settings.
           - `start_at` - Represents when event starts.
           - `end_at` - Represents when event ends.
           - `background_color` - Represents the background color.
           - `foreground_color` - Represents the foreground color that can be used to write on top of a background with 'background' color.
           - `timestamps`
        DESC
      end

      def assignment
        <<~DESC
          Assignment attributes :
      
            - `report` - Represents detailed task accomplishment description.
            - `accomplished` - `true` if assignment is accomplished(done), otherwise `false`.
            - `extra_links` - Represents links(URL) to extra attachments on external storage(Google drive, for example)
            - `timestamps`
        DESC
      end

      def label
        <<~DESC
          Label attributes :
      
            - `title` - Represents label title (unique in student's group scope).
            - `description` - Represents label detailed description.
            - `color` - Represents label's background color.
            - `text_color` - Represents label's text color(Generates automatically and based on background color).
            - `timestamps`
        DESC
      end

      def invite
        <<~DESC
          Invite attributes :
      
          - `email` - Represents email where invite was sent.
          - `invitation_token` - Represents token.
          - `status` - Represents invite current status.
            - `accepted` - The invite was accepted by the recipient.
            - `pending` - The invite was not accepted by the recipient. Default status.
          - `sent_at` - Date and time when the invite was sent.
          - `accepted_at` - Date and time when the invite was accepted by recipient.
          - `timestamps`
        DESC
      end

      def group
        <<~DESC
          Group attributes: 
      
            - `title` - Represents human readable group identity.
            - `number` - Represents main group identity.
            - `timestamps`
        DESC
      end

      def announcement
        <<~DESC
          Announcement attributes :
      
            - `message` - Represents application announcement message.
            - `background_color` - Represents the background color.
            - `foreground_color` - Represents the foreground color that can be used to write on top of a background with 'background' color.
            - `start_at` - Represents time when announcement should appear.
            - `end_at` - Represents time when announcement should disappear.
            - `timestamps`
        DESC
      end

      def identity
        <<~DESC
          Identity attributes :
      
            - `provider` - Represents oauth provider name: #{Identity.providers.keys}
            - `timestamps`
        DESC
      end

      def abuse_report
        <<~DESC
          Abuse report attributes :
      
           - `message` - Represents abuse report message.
           - `user_id` - Represents reported users identity
           - `timestamps`
        DESC
      end

      def bug_report
        <<~DESC
          Bug report attributes :
      
           - `message` - Represents bug report message.
           - `timestamps`
        DESC
      end

      def lecturer
        <<~DESC
          Lecturer attributes :
      
           - `first_name` - Represents lecturer first name
           - `last_name` - Represents lecturer last name
           - `patronymic` - Represents lecturer patronymic 
           - `email` - Represents lecturer contact email address.
           - `phone` - Represents lecturer contact phone number.
           - `active` - `true` if lecturer is available in current time(can ), otherwise `false`
           - `timestamps`
        DESC
      end

      def course
        <<~DESC
          Course attributes :
      
           - `title` - Represents course name(human readable identity).
           - `active` - `true` if course is available in current time(not archived course), otherwise `false`
           - `timestamps`
        DESC
      end

      def audit_event
        <<~DESC
          Audit event attributes :
      
            - `audit_type` - Represents type of the audit event(scope of the event).
            - `details` - Represents additional details information(json).
            - `timestamps`
        DESC
      end

      def statistics_meta
        <<~DESC
          Meta entity attributes :
      
           - `total_count` - Represents the number of records created for all time.
           - `week_count` - Represents the number of records created for the last week.
           - `month_count` - Represents the number of records created for the last month.
           
          Example:
      
          <pre>
          {
            "meta": {
              "user": {
                "total_count": 10,
                "week_count": 1,
                "month_count": 5
              },
              "group": {
                "total_count": 5,
                "week_count": 1,
                "month_count": 2
              }
            }
          }
          </pre>
        DESC
      end

      def settings
        <<~DESC
          Settings attributes :
      
           - `app_contact_username` - Represents contact person's name.
           - `app_contact_email` - Represents contact person's email.
           - `app_title` - Represents application title.
           - `app_short_description` - Represents application short description(may include HTML).
           - `app_description` - Represents application description(may include HTML).
           - `app_extended_description` - Represents application extended description(HTML).
           - `app_terms` - Represents application terms of use(HTML).
        DESC
      end

      def application_logs
        <<~DESC
          Meta entity attributes :
      
           - `file_name` - Represents file name that contains logs.
           - `logs` - Represents last 2000 log rows.
           
          Example: 
      
            <pre>
              {
                "meta": [
                  {
                    "file_name": "application.log",
                    "logs": [
                      "# Logfile created on 2019-10-07 17:08:07 +0300 by logger.rb/61378",
                      "I, [2019-10-07T17:16:44.449328 #1022]  INFO -- : hello world",
                      "E, [2019-10-07T17:16:44.449940 #1022] ERROR -- : hello again"
                    ]
                  }
                ]
              }
            </pre>
        DESC
      end

      def activity_event
        <<~DESC
          Activity event attributes :
      
            - `action` - Represents action of the activity(#{ActivityEvent.actions.keys}).
            - `details` - Represents additional details information(json).
            - `timestamps`
        DESC
      end

      def active_token
        <<~DESC
          Active token attributes :
      
            - `ip_address` - Represents IP address.
            - `browser` - Represents browser name used to claim token(Mobile safari..).
            - `os` - Represents operation system name(Windows, iOS, Linux...).
            - `device_name` - Represents name of the device(iPhone 6..).
            - `device_type` - Represents type of the device(tablet, smartphone...).
            - `timestamps`
        DESC
      end
    end
  end
end
