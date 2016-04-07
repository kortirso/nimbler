Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    use_doorkeeper
    devise_for :users
    resources :tasks, only: [:index, :show, :create]
    namespace :api do
        namespace :v1 do
            resource :profiles do
                get :me, on: :collection
            end
            resources :tasks, only: [:index, :show, :create]
            resources :words, only: :show
        end
    end
    get 'search' => 'search#find', as: 'search'
    root to: 'welcome#index'
    match "*path", to: "application#catch_404", via: :all
end
