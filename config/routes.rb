Rails.application.routes.draw do
  root "jobs#index"

  resources :jobs

  get "up" => "rails/health#show", as: :rails_health_check
end