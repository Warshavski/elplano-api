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
                   unlocks:       'api/v1/users/unlocks'
                 },
                 skip: %i[sessions password]
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      # (see UsersController)
      resource :user, only: :show

      # (see StudentsController)
      resource :student, only: %i[show update]

      # (see GroupsController)
      resource :group, except: %i[new edit]

      # (see EventsController)
      resources :events, except: %i[new edit]
    end
  end
end
