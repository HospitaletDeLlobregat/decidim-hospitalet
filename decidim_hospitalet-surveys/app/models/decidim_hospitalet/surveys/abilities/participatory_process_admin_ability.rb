# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    module Abilities
      # Defines the abilities related to surveys for a logged in process admin user.
      # Intended to be used with `cancancan`.
      class ParticipatoryProcessAdminAbility < Decidim::Abilities::ParticipatoryProcessAdminAbility
        def define_participatory_process_abilities
          super

          can :manage, SurveyResult do |survey_result|
            can_manage_process?(survey_result.feature.participatory_space)
          end
        end
      end
    end
  end
end
