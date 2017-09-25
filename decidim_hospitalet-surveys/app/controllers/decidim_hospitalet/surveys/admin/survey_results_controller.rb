# frozen_string_literal: true
module DecidimHospitalet
  module Surveys
    module Admin
      # This controller allows an admin to manage survey_results from a Participatory Process
      class SurveyResultsController < Admin::ApplicationController
        helper_method :survey_results, :available_scopes, :proposals_feature

        def index
          respond_to do |format|
            format.html do
              @survey_results = survey_results.page(params[:page]).per(50)
            end
            format.csv do
              send_data(SurveyCSVPresenter.new(survey_results).to_data,
                      type: "text/csv; charset=utf-8; header=present",
                      filename: "survey_results_#{Time.now.to_s(:iso8601)}.csv")
            end
          end
        end

        def available_scopes
          @available_scopes ||= current_organization.scopes.map do |scope|
            OpenStruct.new(id: scope.id, name: scope.name[I18n.locale.to_s])
          end
        end

        private

        def survey_results
          @survey_results ||= SurveyResult.where(feature: current_feature).includes(:scope, :user, :feature, :author)
        end

        def survey_result
          @survey_result ||= survey_results.find(params[:id])
        end

        def proposals_feature
          Decidim::Feature.where(participatory_process: current_participatory_process, manifest_name: :proposals).first
        end
      end
    end
  end
end
