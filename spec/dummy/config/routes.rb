Dummy::Application.routes.draw do
  devise_for :users, controllers: { masquerades: "users/masquerades" }
  devise_for :admin_users, :class_name => 'Admin::User'

  root :to => 'dashboard#index'

  namespace :admin do
    root :to => 'dashboard#index'
  end
end

