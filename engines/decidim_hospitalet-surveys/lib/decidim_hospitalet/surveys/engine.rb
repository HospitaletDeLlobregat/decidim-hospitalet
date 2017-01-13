# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    # This is the engine that runs on the public interface of the surveys module.
    # It mostly handles rendering the survey.
    class Engine < ::Rails::Engine
      isolate_namespace DecidimHospitalet::Surveys

      routes do
        resources :survey_results, only: [:create, :new, :index]
        root to: "survey_results#index"
      end
    end
  end
end
