require "decidim/core/test/factories"
require "decidim/admin/test/factories"
require "decidim/comments/test/factories"

FactoryGirl.define do
  factory :surveys_feature, class: Decidim::Feature do
    name { { ca: "Enquestes", es: "Encuestas" } }
    manifest_name :hospitalet_surveys
    participatory_process
  end

  factory :survey_result, class: DecidimHospitalet::Surveys::SurveyResult do
    feature
    user { create(:user, organization: feature.organization) }
    scope { create(:scope, organization: feature.organization) }
  end
end
