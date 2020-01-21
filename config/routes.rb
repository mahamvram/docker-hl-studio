Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end
  unauthenticated do
    root to: "home#index"
  end
  resources :dashboard do
    get 'current_task', on: :collection
    # get 'account', on: :collection
    # post 'create_account', on: :collection
  end
  resources :accounts do
    get 'my_workspace'
  end
  resources :users
  get '/nodes/new/(:parent_id)', to: 'nodes#new', as: :new_node
  get '/nodes/task_form/(:parent_id)', to: 'nodes#task_form', as: :task_form
  get '/nodes/edit_task_form/(:node_id)', to: 'nodes#edit_task_form', as: :edit_task_form
  get '/nodes/episode_form/(:parent_id)', to: 'nodes#episode_form', as: :episode_form
  resources :nodes, only: [:index, :create, :edit, :show] do
    resources :assignments
    get  'task_node_creation', on: :collection
    post 'create_episode_form', on: :collection
    post 'create_task_form', :on => :collection
    patch 'update_task_form', :on => :collection
    get 'user_info', on: :collection
  end
  resources :assignments do
    get "task_review"
    resources :notes
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
