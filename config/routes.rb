Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/index' => 'user#index'
  get 'photos/index/:id' => 'photo#index'
  root :to => 'user#index'
end
