# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'offers#index'

  resources :offers, except: %i[show] do
    collection do
      get :suggestions
    end
  end

  resources :customers, except: %i[show] do
    collection do
      get :suggestions
      get :autocomplete
    end
  end

  resources :companies, except: %i[show] do
    collection do
      get :suggestions
      get :autocomplete
    end
  end
end
