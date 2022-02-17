# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/alive", to: "status#alive", as: :alive
  get "/ready", to: "status#ready", as: :ready

  # mount the Engine routes in their own namespace
  mount AdminEngine::Engine => "engines/admin_engine/", as: "admin_engine"
  mount UserEngine::Engine => "engines/user_engine/", as: "user_engine"

  root "status#version"

  # catch all unknown routes to NOT throw a FATAL ActionController::RoutingError
  match "*path", to: "application#error_404", via: [:get, :post]
end
