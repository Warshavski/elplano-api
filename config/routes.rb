Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  use_doorkeeper do
    # No need to register client application
    skip_controllers :applications, :authorized_applications
  end

  root to: 'about#show', defaults: { format: 'json' }

  scope :api, defaults: { format: 'json' } do
    scope :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/users/registrations',
                   confirmations: 'api/v1/users/confirmations',
                   passwords:     'api/v1/users/passwords',
                   unlocks:       'api/v1/users/unlocks'
                 },
                 skip: %i[sessions]
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      namespace :admin do
        #(see Admin::SettingsController)
        resource :settings, only: :update

        namespace :system do
          # (see Admin::System::HealthController)
          resource :health, only: :show, controller: 'health'

          # (see Admin::System::InformationController)
          resource :information, only: :show, controller: 'information'
        end

        # (see Admin::UsersController)
        resources :users, except: %i[new edit create]
      end

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

        # (see Group::StudentsController)
        resources :students, only: %i[index show]
      end

      # (see InvitesController)
      resources :invites, only: %i[index show update], param: :token

      # (see PasswordsController)
      resource :password, only: :update

      # (see StudentsController)
      resource :student, only: %i[show update]

      # (see UsersController)
      resource :user, only: :show
    end
  end

  # (see UploadsController)
  resource :uploads, only: :create
end
