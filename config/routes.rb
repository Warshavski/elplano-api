require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  use_doorkeeper do
    # No need to register client application
    skip_controllers :applications, :authorized_applications
  end

  root to: 'about#show', defaults: { format: 'json' }

  scope :api, defaults: { format: 'json' } do
    mount Sidekiq::Web => '/sidekiq'

    scope :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/users/registrations',
                   confirmations: 'api/v1/users/confirmations',
                   passwords:     'api/v1/users/passwords',
                   unlocks:       'api/v1/users/unlocks',
                   sessions:      'api/v1/users/sessions'
                 }
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :activity do
        # (see Activity::EventsController)
        resources :events, only: :index

        # (see Activity::TokensController)
        resources :tokens, only: :index
      end

      namespace :admin do
        namespace :activity do
          # (see Admin::Activity:EventsController)
          resources :events, only: :index
        end

        # (see Admin::AnnouncementsController)
        resources :announcements, except: %i[new edit]

        # (see Admin::EmailsController)
        resources :emails, only: :create

        namespace :emails do
          # (see Admin::Emails::MetricsController)
          resource :metrics, only: :show
        end

        # (see Admin::GroupsController)
        resources :groups, only: %i[index show]

        # (see Admin::LabelsController)
        resources :labels, only: %i[index show]

        # (see Admin::LogsController)
        resource :logs, only: :show

        namespace :reports do
          # (see admin::Reports::AbusesController)
          resources :abuses, only: %i[index show destroy]

          # (see Admin::Reports::BugsController)
          resources :bugs, only: %i[index show destroy]
        end

        #(see Admin::SettingsController)
        resource :settings, only: :update

        # (see Admin::StatisticsController)
        resource :statistics, only: :show

        namespace :system do
          # (see Admin::System::HealthController)
          resources :health, only: :show, controller: 'health', param: :type

          # (see Admin::System::InformationController)
          resource :information, only: :show, controller: 'information'
        end

        # (see Admin::UsersController)
        resources :users, except: %i[new edit create]
      end

      # (see AnnouncementsController)
      resources :announcements, only: :index

      namespace :audit do
        # (see Audit::EventsController)
        resources :events, only: :index
      end

      # (see ClassmatesController)
      resources :classmates, only: %i[index show]

      # (see EventsController)
      resources :events, except: %i[new edit]

      # (see GroupsController)
      resource :group, except: %i[new edit]

      namespace :group do
        # (see CoursesController)
        resources :courses, except: %i[new edit]

        # (see Group::InvitesController)
        resources :invites, only: %i[index show create]

        # (see Group::LecturersController)
        resources :lecturers, except: %i[new edit]
      end

      # (see InvitesController)
      resources :invites, only: %i[index show update], param: :token

      # (see LabelsController)
      resources :labels, except: %i[new edit]

      # (see PasswordsController)
      resource :password, only: :update

      # (see StatusesController)
      resource :status, only: %i[show update destroy]

      namespace :reports do
        # (see Reports::AbusesController)
        resources :abuses, only: :create

        # (see Reports::BugsController)
        resources :bugs, only: :create
      end

      namespace :tasks do
        # (see Tasks::StatisticsController)
        resource :statistics, only: :show
      end

      # (see TasksController)
      resources :tasks, except: %i[new edit] do
        # (see AssignmentsController)
        resource :assignment, only: %i[show update]
      end

      # (see UsersController)
      resource :user, only: %i[show update destroy]

      namespace :users do
        # (see IdentitiesController)
        resources :identities, only: %i[index create destroy]
      end
    end
  end

  # (see UploadsController)
  resource :uploads, only: :create
end
