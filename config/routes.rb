# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

Rails.application.routes.draw do
  root "pages#index"

  # The public marketing site (static pages).
  scope "/about", as: "about" do
    get "/", to: "pages#about"
    get "/our-goals", to: "pages#about_our_goals", as: "our_goals"
    get "/exposure", to: "pages#about_exposure", as: "exposure"
    get "/dual-license", to: "pages#about_dual_license", as: "dual_license"
    get "/accessibility", to: "pages#accessibility", as: "accessibility"
  end
  get "/contribute", to: "pages#contribute", as: "contribute"
  get "/newsletter", to: "pages#newsletter", as: "newsletter"

  # The public library (read-only): browse/search and a book's page. "Ebooks"
  # is the marketing name for the same catalog, so it links here.
  resources :books, only: %i[index show]
  get "/ebooks", to: "books#index", as: "ebooks"
  resources :tags, only: :show

  resource :session
  resource :first_run, only: %i[new create]
  resources :passwords, param: :token

  # The librarian's first write surface: record a discovered book. A discovery
  # is a domain operation named for the noun, not a table editor.
  resources :discoveries, only: %i[new create]
  namespace :catalog do
    resources :expressions
    resources :works
    resources :items
    resources :conditions
    resources :manifestations
    resources :series
    resources :languages
    resources :form_of_expressions
    resources :carriers
    resources :form_of_works
    resources :intended_audiences
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
