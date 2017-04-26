# frozen_string_literal: true

module DecidimHospitalet
  module Surveys
    # Exposes the proposal resource so users can view and create them.
    class SurveyResultsController < DecidimHospitalet::Surveys::ApplicationController
      include Decidim::FormFactory
      before_action :authenticate_user!, only: [:new, :create]

      helper_method :available_scopes, :answered_surveys, :proposals_feature

      def new
        @form = form(SurveyForm).from_params({})
      end

      def create
        @form = form(SurveyForm).from_params(params)

        CreateSurveyResult.call(@form, current_feature, current_user) do
          on(:ok) do |_survey_result|
            flash[:notice] = I18n.t("surveys.create.success", scope: "decidim_hospitalet")
            redirect_to action: :index
          end

          on(:invalid) do |_survey_result|
            flash.now[:alert] = I18n.t("surveys.create.error", scope: "decidim_hospitalet")
            render :new
          end
        end
      end

      def available_scopes
        @available_scopes ||= current_organization.scopes.where.not(id: answered_surveys.pluck(:decidim_scope_id))
      end

      private

      def answered_surveys
        @answered_surveys ||= SurveyResult.where(user: current_user, feature: current_feature)
      end

      def proposals_feature
        Decidim::Feature.where(participatory_process: current_participatory_process, manifest_name: :proposals).first
      end
    end
  end
end
