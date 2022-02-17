Rails.application.routes.draw do
  mount AdminEngine::Engine => "/admin_engine"
end
