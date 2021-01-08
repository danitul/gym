Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :trainers, only: [] do
        resources :workouts, only: [:show, :create, :update, :destroy]
        resources :trainees, only: [:index, :update] do
          post 'assign/:workout_id', to: 'trainees#update'
        end
      end
      resources :trainees, only: [] do
        resources :workouts, only: [:index] do
          post 'choose/:trainer_id', to: 'workouts#update'
        end
      end
    end
  end
end
