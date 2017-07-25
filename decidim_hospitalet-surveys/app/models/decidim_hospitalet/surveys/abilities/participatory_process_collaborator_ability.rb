# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    module Abilities
      # Defines the abilities related to surveys for a logged in process admin user.
      # Intended to be used with `cancancan`.
      class ParticipatoryProcessCollaboratorAbility < Decidim::Abilities::ParticipatoryProcessCollaboratorAbility
        def define_participatory_process_abilities
          super

          can [:create, :preview], SurveyResult do |survey_result|
            can_manage_process?(survey_result.feature.participatory_process)
          end
        end
      end
    end
  end
end
