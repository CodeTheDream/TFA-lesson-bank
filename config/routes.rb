Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions"}
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  
  root to: 'pages#landing_page'
  
  # devise_scope :user do
  #   get '/users/sign_out' => 'devise/sessions#destroy'
  # end
  devise_scope :user do
    get '/users' => 'users/registrations#index'
    get '/users/:id' => 'users/registrations#show', as: 'user_show'
    get '/users/:id/edit' => 'users/registrations#edit', as: 'user_edit'
    put '/users/:id' => 'users/registrations#update', as: 'user_update'
    delete '/users/:id' => 'users/registrations#destroy', as: 'user_delete'
    post '/users/sign_in' => 'users/sessions#create'
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # resources :courses do
  #   put :favorite, on: :member
  # end

  get '/search' => 'pages#search', :as => 'search_page'
  


  resources :documents
  resources :courses do 
    member do
      get :favorite
      get :unfavorite
    end
    member do
      get :download
    end 
    resources :lessons do
      member do
        get :download
      end
    end
    resources :documents do
      collection do
        get :course_index
      end
    end
    
  end
  resources :lessons do
    #member do
    #  get :download
    #end
    resources :documents do
      collection do
        get :lesson_index
      end
    end
  end
  resources :tags
  resources :key_words

end
