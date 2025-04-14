# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Devise::SessionsController.include(ActiveHashcash)
  Decidim::Devise::SessionsController.class_eval do
    before_action :check_hashcash, only: :create
  end

  Decidim::Devise::RegistrationsController.include(ActiveHashcash)
  Decidim::Devise::RegistrationsController.class_eval do
    before_action :check_hashcash, only: :create
  end
end
