# frozen_string_literal: true
require "decidim/core/test/factories"
require "decidim/comments/test/factories"
require "decidim/proposals/test/factories"
require "decidim/participatory_processes/test/factories"

FactoryGirl.define do
  factory :surveys_feature, parent: :feature do
    name { { ca: "Enquestes", es: "Encuestas" } }
    manifest_name :hospitalet_surveys
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :survey_result, class: DecidimHospitalet::Surveys::SurveyResult do
    feature
    user { create(:user, organization: feature.organization) }
    scope { create(:scope, organization: feature.organization) }
    selected_categories { create_list(:category, 2, participatory_space: feature.participatory_space).map(&:id) }
  end
end
