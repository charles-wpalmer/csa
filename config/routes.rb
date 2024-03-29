# Defines the app's routes
# @author Chris Loftus
Rails.application.routes.draw do

  # Only need to create, and show
  resources :replies, only: [:new, :create, :show]

  # Need all for posts
  resources :posts

  # Remap URLS for creating replies, to keep opaque URI's
  # When a reply has a post_id, and a parent_id
  get 'posts/:post_id/replies/new/replies/:parent_id', to: 'replies#new'
  post 'posts/:post_id/replies/new/replies/:parent_id', to: 'replies#create'

  # Maps replies to posts, to autogenerate the URLS
  resources :posts do
    resources :replies, :only=>[:new, :create, :show]
  end

  resources :users do
    # We add a special route to support the search field
    get 'search', on: :collection
  end
  
  # At the moment we only provide a JSON web service
  # API for user account managment. This is provided
  # as an example. See the rest_client folder.
  namespace :api, defaults: {format: :json} do
    resources :users, except: [:new, :edit] do
      get 'search', on: :collection
    end

    resources :posts, except: [:new, :edit, :delete, :update, :destroy]
    resources :sessions, only: [:create]
  end

  # No point allowing the editing or update of an existing broadcast
  resources :broadcasts, except: [:edit, :update]

  # A singleton resource and so no paths requiring ids are generated
  # Also, don't want to support editing of the session
  resource :session, only: [:new, :create, :destroy]

  # This is just to support the landing page
  get 'home', to: 'home#index', as: :home

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
