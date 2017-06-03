# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'offers#index'

  resources :offers, except: %i[show] do
    collection do
      get :autocomplete
    end
  end

  resources :customers, only: %i[] do
    collection do
      get :autocomplete
    end
  end
end
