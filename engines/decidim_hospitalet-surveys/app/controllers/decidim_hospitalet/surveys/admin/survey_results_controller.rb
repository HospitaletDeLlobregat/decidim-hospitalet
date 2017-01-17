# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    module Admin
      # This controller allows an admin to manage survey_results from a Participatory Process
      class SurveyResultsController < Admin::ApplicationController
        helper_method :survey_results

        def new
          @form = form(SurveyResultForm).instance
        end

        def create
          @form = form(SurveyResultForm).from_params(params, current_feature: current_feature)

          CreateSurveyResult.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("survey_results.create.success", scope: "decidim_hospitalet.surveys.admin")
              redirect_to survey_results_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_results.create.invalid", scope: "decidim_hospitalet.surveys.admin")
              render action: "new"
            end
          end
        end

        private

        def survey_results
          @survey_results ||= SurveyResult.where(feature: current_feature)
        end

        def survey_result
          @survey_result ||= survey_results.find(params[:id])
        end
      end
    end
  end
end
