Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :survivors, only: [:index, :create, :update] do
        member do
          post :flag_infection
        end
      end

      post :trade_resources, to: 'trades#trade_resources'

      resources :reports, only: []  do
        collection do
          get :infected_survivors
          get :not_infected_survivors
          get :resources_by_survivor
          get :lost_infected_points
        end
      end
    end
  end
end
