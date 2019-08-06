# frozen_string_literal: true

module Api
  module V1
    module Admin
      module System
        # Api::V1::Admin::System::InformationController
        #
        #   Used to administrate system resources usage
        #     (get information about CPU, RAM and DISK)
        #
        class InformationController < ApplicationController
          # GET : api/v1/admin/systems
          #
          # Get usage information about CPU, RAM, and DISK
          #
          def show
            render_meta ::System::Information.call
          end
        end
      end
    end
  end
end
