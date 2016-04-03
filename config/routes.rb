Rails.application.routes.draw do
    devise_for :users
    resources :tasks, only: [:index, :show, :create]
    root to: 'welcome#index'
    match "*path", to: "application#catch_404", via: :all
end
