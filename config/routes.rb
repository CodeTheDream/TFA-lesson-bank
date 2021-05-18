Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#landing_page'
  get '/search' => 'pages#search', :as => 'search_page'
  resources :documents
  resources :courses do 
    resources :lessons
  end
end
