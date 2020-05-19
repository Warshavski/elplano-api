# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::EmailsController
      #
      #   Users emails management
      #
      class EmailsController < Admin::ApplicationController
        specify_title_header 'Emails'

        # POST : api/v1/admin/emails
        #
        # Send email to the particular user
        #   (unlock_instruction, confirmation_instructions)
        #
        def create
          mailing_params = validate_params

          User.find(mailing_params[:user_id]).tap do |user|
            user.public_send("resend_#{mailing_params[:type]}_instructions")
          end

          render_meta({ message: I18n.t(:'generic.messages.email_sent') }, status: :created)
        end

        private

        def validate_params
          validate_with(::Admin::Emails::CreateContract.new, params[:mailing])
        end
      end
    end
  end
end
