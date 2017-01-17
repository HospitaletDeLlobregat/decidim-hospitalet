# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # This is the engine that runs on the public interface of the surveys module.
    class AdminEngine < ::Rails::Engine
      isolate_namespace DecidimHospitalet::Surveys::Admin

      paths["db/migrate"] = nil

      routes do
        resources :survey_results, only: [:index, :new, :create]
        root to: "survey_results#index"
      end

      def load_seed
        nil
      end
    end
  end
end
