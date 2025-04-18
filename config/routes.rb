Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    post 'signup', to: 'registrations#create'

    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get 'validate_token', to: 'sessions#validate_token' # Nova rota

    get 'profile', to: 'profile#show'

    resources :projects, only: [:index, :create, :show, :destroy, :update]
    resources :tech_tags, only: [:index]
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
