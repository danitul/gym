Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :trainers, only: [] do
        resources :workouts, only: [:show, :create, :update, :destroy], controller: 'trainers/workouts'
        resources :trainees, only: [:index], controller: 'trainers/trainees' do
          put 'assign/:workout_id', to: 'trainers/trainees#update'
        end
      end
      resources :trainees, only: [] do
        resources :workouts, only: [:index], controller: 'trainees/workouts'
        resources :trainers, only: [:index], controller: 'trainees/trainers'
      end
    end
  end
end
