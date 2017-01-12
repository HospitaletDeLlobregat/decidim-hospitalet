# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    # Includes helpers to build the survey form, in order to extract
    # logic from the views.
    #
    module SurveysHelper
      def survey_genders
        SurveyResult::GENDERS.map do |gender|
          [
            t("questions.genders.#{gender}", scope: "decidim_hospitalet.surveys"),
            gender
          ]
        end
      end

      def survey_age_groups
        DecidimHospitalet::Surveys::SurveyResult::AGE_GROUPS
      end

      def survey_towns
        DecidimHospitalet::Surveys::Towns::TOWNS.map { |id, name| [name, id] }
      end
    end
  end
end
