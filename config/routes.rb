Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants do
    resources :bulk_discounts, controller: 'merchant_bulk_discounts',
                                        only: %i[edit update index show new create destroy]
    resources :items, only: %i[index show edit update new create]
    resources :dashboard, only: [:index]
    resources :bulk_discount, only: %i[:show]
    resources :invoices, only: %i[index show] do
      resources :invoice_items, only: %i[edit update]
    end
    # resources :invoice_items, only: %i[edit update]
  end

  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'
    resources :merchants, only: %i[index show edit update new create]
    resources :invoices, only: %i[index show edit update]
  end
end
