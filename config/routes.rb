# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
    mount ActiveHashcash::Engine, at: "hashcash" # http://localhost:3000/hashcash
  end

  resources :entities

  mount Decidim::Core::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
