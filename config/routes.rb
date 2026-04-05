Rails.application.routes.draw do
  scope "(:locale)", locale: /en|zh-CN/ do
    get "skus/show"
    get "categories/index"
    get "categories/show"
    root "home#index"
    get "about", to: "home#about"
    get "all_products", to: "home#all_products"
    get "contact", to: "home#contact"
    post "contact", to: "home#create_contact"
    get "warranty", to: "home#warranty"
    post "warranty_inquiry", to: "home#create_warranty_inquiry"

    namespace :admin do
      root to: "dashboard#index"
      get "dashboard", to: "dashboard#index"
      resources :categories
      resources :skus do
        collection do
          get :export
          get :import_page
          post :import
          patch :update_positions
        end
        member do
          delete :delete_image
          delete :delete_manual
          delete :delete_spec_sheet
        end
      end
      resources :contact_messages, only: [:index, :show, :destroy]
      resources :warranty_inquiries, only: [:index, :show, :destroy]
      resources :warranty_pdfs do
        member do
          get :download
        end
      end
      resources :users, only: [:index, :show, :destroy]
      resources :visit_records, only: [:index] do
        collection do
          delete :clean
        end
      end
    end

    %w[a b c].each do |kind|
      get kind, to: "channels#index", defaults: { kind: kind }, as: "#{kind}_channel"
    end

    resources :categories, only: [:index, :show]
    resources :skus, only: [:show]
  end

  devise_for :users
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
