# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    module Admin
      # This controller allows an admin to manage survey_results from a Participatory Process
      class SurveyResultsController < Admin::ApplicationController
        helper_method :survey_results, :available_scopes

        def new
          @form = form(SurveyResultForm).instance
        end

        def create
          @form = form(SurveyResultForm).from_params(params, current_feature: current_feature)

          Admin::CreateSurveyResult.call(@form) do
            on(:ok) do |success_message|
              flash[:notice] = I18n.t("survey_results.create.#{success_message}", scope: "decidim_hospitalet.surveys.admin")
              redirect_to survey_results_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_results.create.invalid", scope: "decidim_hospitalet.surveys.admin")
              render action: "new"
            end
          end
        end

        def edit
          @form = form(SurveyResultForm).from_model(survey_result)
        end

        def update
          @form = form(SurveyResultForm).from_params(params, current_feature: current_feature)

          UpdateSurveyResult.call(@form, survey_result) do
            on(:ok) do
              flash[:notice] = I18n.t("survey_results.update.success", scope: "decidim_hospitalet.surveys.admin")
              redirect_to survey_results_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_results.update.invalid", scope: "decidim_hospitalet.surveys.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          survey_result.destroy!

          flash[:notice] = I18n.t("survey_results.destroy.success", scope: "decidim_hospitalet.surveys.admin")

          redirect_to survey_results_path
        end

        def available_scopes
          @available_scopes ||= current_organization.scopes
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
