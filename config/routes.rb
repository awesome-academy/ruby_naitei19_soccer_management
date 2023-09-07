Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # User scope
    scope module: "user" do
      root "static_pages#index"
      get "/", to: "static_pages#index"
    end

    # Admin scope
    namespace :admin do
      get "/", to: "static_pages#index"
      get  "/signup",  to: "users#index"

      # resources
      resources :users
      resources :football_pitches
    end
  end
end
