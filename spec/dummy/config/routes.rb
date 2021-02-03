Dummy::Application.routes.draw do
  devise_for :users, controllers: { masquerades: 'users/masquerades' }
  devise_for :admin_users, class_name: Admin::User.name
  devise_for :students, class_name: Student.name

  root to: 'dashboard#index'

  get '/extra_params', to: 'dashboard#extra_params'

  resources :masquerades_tests
  resources :students, only: :index

  namespace :admin do
    root to: 'dashboard#index'
  end
end
