# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # This is the engine that runs on the public interface of the surveys module.
    class AdminEngine < ::Rails::Engine
      isolate_namespace DecidimHospitalet::Surveys::Admin

      paths["db/migrate"] = nil

      routes do
        resources :survey_results
        root to: "survey_results#index"
      end

      Decidim.configure do |config|
        config.admin_abilities += [
          "DecidimHospitalet::Surveys::Abilities::AdminAbility",
          "DecidimHospitalet::Surveys::Abilities::ParticipatoryProcessAdminAbility",
          "DecidimHospitalet::Surveys::Abilities::ParticipatoryProcessCollaboratorAbility"
        ]
      end

      def load_seed
        nil
      end
    end
  end
end
